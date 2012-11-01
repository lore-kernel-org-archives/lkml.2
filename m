Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992513Ab2KAUaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:30:19 -0400
Received: from spam1.webland.se ([91.207.112.90]:65456 "EHLO spam1.webland.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639Ab2KAUaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:30:12 -0400
From: Arvid Brodin <Arvid.Brodin@xdin.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Thread-Topic: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Thread-Index: AQHNtuHiwCMp4/hqTEiwDalQNzY3mZfSSr+AgAMT2QA=
Date: Thu, 1 Nov 2012 20:22:07 +0000
Message-ID: <5092D9EE.80009@xdin.com>
References: <50904066.4060404@xdin.com>
 <20121030212217.GD2616@ZenIV.linux.org.uk>
In-Reply-To: <20121030212217.GD2616@ZenIV.linux.org.uk>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120410
 Thunderbird/8.0
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <2CE08E492236A548B7B6933C15CA7EB8@redbull.xdin.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-30 22:22, Al Viro wrote:
> On Tue, Oct 30, 2012 at 09:02:33PM +0000, Arvid Brodin wrote:
> 
>> +config PROC_TEXT_MD5SUM
>> +	bool "/proc/<pid>/text_md5sum support"
>> +	depends on PROC_FS
>> +	select CRYPTO
>> +	select CRYPTO_MD5
>> +	help
>> +	  Read /proc/<pid>/text_md5sum to get the kernel to perform an MD5
>> +	  checksum over the process' text segment and print the result. Can be
>> +	  used to make sure a process' code has not been tampered with.
> 
> Sorry, but this is pointless.  Any attacker capable of modifying the code
> will be just as capable of modifying pointers to functions in data segment.
> IOW, you are not making sure of anything useful.

On 2012-10-30 22:23, Cyrill Gorcunov wrote:
> I don't think this increments security by any means. start/end-code are rather
> informative fields which are set when program being started, so one can ptrace
> it, alloc new exec area, put evil code there, tuneup cs:ip and restore original
> program contents, you won't even notice that.

You are both correct of course. Actually, I was kind of sloppy when I wrote the
Kconfig help text. The following more accurately describes the intended use. Would
this make the patch more acceptable?

+config PROC_TEXT_MD5SUM
+	bool "/proc/<pid>/text_md5sum support"
+	depends on PROC_FS
+	select CRYPTO
+	select CRYPTO_MD5
+	help
+	  Read /proc/<pid>/text_md5sum to get the kernel to perform an MD5
+	  checksum over the process' text segment and print the result. This
+	  can detect some cases where the system RAM has been disturbed by
+	  e.g. EMC or cosmic radiation (on systems where ECC is not available).
+	  It might also detect some accidental or malicious modifications of
+	  executables, where the perpetrator has not bothered to cover up the
+	  tracks.


-- 
Arvid Brodin | Consultant (Linux)
XDIN AB | Knarrarnäsgatan 7 | SE-164 40 Kista | Sweden | xdin.com