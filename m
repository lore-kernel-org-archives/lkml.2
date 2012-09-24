Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2IXUo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:44:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40504 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab2IXUo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:44:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mark Salter <msalter@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
	<20120922114549.GA11610@moon>
	<20120922132046.GA4260@flint.arm.linux.org.uk>
	<20120922114723.d7f07fb6.akpm@linux-foundation.org>
	<1348503709.20929.40.camel@deneb.redhat.com>
	<20120924164942.GH16532@moon> <20120924174256.GD24172@moon>
	<87lifzuvey.fsf@xmission.com> <20120924185119.GI16532@moon>
	<20120924203512.GF24172@moon>
Date: Mon, 24 Sep 2012 13:44:47 -0700
In-Reply-To: <20120924203512.GF24172@moon> (Cyrill Gorcunov's message of "Tue,
	25 Sep 2012 00:35:12 +0400")
Message-ID: <87bogvup4w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18JTINcX8UxDPIER6a8PCWwpKN8WVKYb4c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: openvz.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Cyrill Gorcunov <gorcunov@openvz.org>
X-Spam-Relay-Country: 
Subject: Re: sys_kcmp
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> On Mon, Sep 24, 2012 at 10:51:19PM +0400, Cyrill Gorcunov wrote:
>> > I expect what you want is a call to access_ok, rather than hard coding
>> > details about task layout here.  This test certainly looks wrong
>> > for a 32bit process on a 64bit kernel. If I read your test right it
>> > appears I can set values of say 0x100000000 on a 32bit process...
>> > 
>> > As for mmap_min_addr I would expect your find_vma check would make that
>> > test unnecessary, simply by not finding a vma...
>> 
>> Good point, Eric, thanks! I'm cooking a new patch now.
>
> Btw, Eric, I somehow miss one bit -- how would you set this 0x100000000
> if TASK_SIZE is a macro which does check for TIF_ADDR32 and sets limit
> acordingly? What i'm missing?

How odd.  Last time I had looked TASK_SIZE was a simple constant.

Still I wonder a little if all architectures currently run from 0 to
TASK_SIZE, for address space available.  I seem to remember there have
been some exceptions to that rule.  But I can't recall what they were.

Eric
