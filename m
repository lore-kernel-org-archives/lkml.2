Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2B2OEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:04:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab2B2OEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:04:32 -0500
Message-ID: <4F4E3059.7040004@redhat.com>
Date: Wed, 29 Feb 2012 11:04:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab>
In-Reply-To: <20120229134556.GG21224@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-02-2012 10:45, Borislav Petkov escreveu:
> On Wed, Feb 29, 2012 at 09:52:33AM -0300, Mauro Carvalho Chehab wrote:
> 
> [snip a bunch of crap I'm tired of correcting again, for the 100th time]
> 
>> What I'm saying is that, we should, at least, add 4 fields there, instead of one:
>>
>> 	- severity
>> 	- location
> 
> I've already explained to you why this format doesn't fit the MCE
> tracepoint - go and read my replies to you again.

No, you didn't. Every time i touch on this point, you just say that it doesn't
fit without giving any explanation why not.

The severity is there, even on your patches, but encoded as string:

+#define PR_EMERG	BIT(0)
+#define PR_WARNING	BIT(1)

There are, actually, 3 variants, on Intel MCA:

	- corrected error;
	- uncorrected error (bit 61 of status);
	- uncorrected, recoverable error (bit 61 + bit 56 of status).

The location is also there encoded at the MCA. It is specific to the type
of the error, but all errors happen somewhere: a CPU, a BUS, a memory, ...


>> 	- silkscreen_label
> 
> ditto.

ditto: all errors happen somewhere. The silkscreen label is the first 
replaceable unit to be replaced by the user, in order to get rid of the
error.

> 
>> 	- error_msg
> 
> [ snip more bullshit ]
> 

Running away from this discussion won't help at all. 

Regards,
Mauro
