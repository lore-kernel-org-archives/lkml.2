Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab0GUNly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:41:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab0GUNlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:41:52 -0400
Message-ID: <4C46F930.1040506@suse.cz>
Date: Wed, 21 Jul 2010 15:42:08 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Zheng, Jiajia" <jiajia.zheng@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: "make rpm" failed with parameter "--scm-only"
References: <A24AE1FFE7AEC5489F83450EE98351BF1BD77643B1@shsmsx502.ccr.corp.intel.com> <20100715084233.GA5835@sepie.suse.cz> <20100720132851.GA31205@sepie.suse.cz> <A24AE1FFE7AEC5489F83450EE98351BF1BDE3704AC@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <A24AE1FFE7AEC5489F83450EE98351BF1BDE3704AC@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.7.2010 03:30, Zheng, Jiajia wrote:
> Michal Marek wrote:
>> were you able to test the fix? I'd like to send it to Linus.
>>
> Thank you. This patch works OK. 

Thanks a lot for testing it.

> But I still saw below warnings. Of course, it was not introduced by your patch because that I saw such warnings before. Could you also take a look if there's some problem with Makefile? 
> ...
> + make clean
> make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.

I found the explanation in the make info page:

`warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.'
     In order for `make' processes to communicate, the parent will pass
     information to the child.  Since this could result in problems if
     the child process isn't actually a `make', the parent will only do
     this if it thinks the child is a `make'.  The parent uses the
     normal algorithms to determine this (*note How the `MAKE' Variable
     Works: MAKE Variable.).  If the makefile is constructed such that
     the parent doesn't know the child is a `make' process, then the
     child will receive only part of the information necessary. [...]

Which is our case: The parent make only sees the rpmbuild call. The fix
would probably be to clear all make environment variables before running
rpmbuild.

> + make -j4
> make[2]: warning: -jN forced in submake: disabling jobserver mode.

Another symptom of the same problem.


> I got a RPM package: kernel-2.6.35rc5wl+-6.x86_64.rpm

Great :).

Michal
