Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0I1Iuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0I1Iue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:50:34 -0400
Message-ID: <4CA1AC50.7000801@redhat.com>
Date: Tue, 28 Sep 2010 10:50:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alexander Graf <agraf@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com> <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de> <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de> <4CA06147.7080805@redhat.com> <C725B379-9631-46E4-A825-E43A5120681E@suse.de> <4CA06373.5030501@redhat.com> <4CA112D1.2020004@zytor.com>
In-Reply-To: <4CA112D1.2020004@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 11:55 PM, H. Peter Anvin wrote:
> On 09/27/2010 02:27 AM, Avi Kivity wrote:
> >
> >  I don't have write permissions for the spec.  If you can verify that all
> >  existing and future hardware will mask NMI after STI and convince the
> >  spec owners to update the specifications, I'm all for it; it's certainly
> >  a cleaner solution.
> >
>
> I'm trying to see if this is doable.  As you can well imagine, though,
> it takes time.

Joerg, can you look at this from the AMD side?

First, do AMD processors block NMI after an IF-enabling STI?  The 
documentation explicitly states that they don't:

> Sets the interrupt flag (IF) in the rFLAGS register to 1, thereby 
> allowing external interrupts received on
> the INTR input. Interrupts received on the non-maskable interrupt 
> (NMI) input are not affected by this
> instruction.

though that may refer to the general effect of EFLAGS.IF, not STI.

Second, if NMIs are blocked, is it possible to retro-document this?

Personally I think the safer route is to take the patch.  There are 
other processors besides Intel and AMD and we can't test all of them, 
not to mention various emulators and virtual machine monitors out there.

-- 
error compiling committee.c: too many arguments to function

