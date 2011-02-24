Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1BXMva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:51:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1BXMv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:51:27 -0500
Message-ID: <4D665449.4050908@redhat.com>
Date: Thu, 24 Feb 2011 14:51:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: Nikola Ciprich <extmaillist@linuxbox.cz>, KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz> <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz>
In-Reply-To: <20110224124151.GK25673@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 02:41 PM, Nikola Ciprich wrote:
> >  Yes.  If you have udis86 and udis86-devel installed when building it,
> >  it's even better.
> yes, now I remember! I've done some tracing for You already..
>
> >  You don't have to execute qemu-kvm under it, if you have a running
> >  instance you can run trace-cmd in parallel and it will record whatever's
> >  happening.
> I've uploaded the report for You here:
> nelide.cz/downloads/nik/report.txt.xz
>

The only activity I can see is the timer interrupt, so I'm afraid a 
bisect is needed.

If you let git bisect just kvm, it'll be a bit faster:

$ git bisect $BAD $GOOD virt/kvm arch/x86/kvm

-- 
error compiling committee.c: too many arguments to function

