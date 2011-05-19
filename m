Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab1ESMxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:53:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50749 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab1ESMxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=etXJxene0oiCMSB2P5iXy0vewG2PPH7jot0ZsD8HRYZ3hv+BoMtYQOSQy06Sc1P99O
         AoDovwrpfMP9QkdaYPt/T5ODGAqKN4rK5ceZ6nQ2OwOpla1q76ZZhfQuFzJJ0XJF++TE
         T4X5OQqNGx1sUGyvWuuW1NhPzIT17dnnBUn2A=
MIME-Version: 1.0
In-Reply-To: <20110519104330.GA25179@zod.rchland.ibm.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-4-git-send-email-ericvh@gmail.com>
	<20110519104330.GA25179@zod.rchland.ibm.com>
Date: Thu, 19 May 2011 07:53:34 -0500
Message-ID: <BANLkTinyhUiEfE4R7a4WyXSy6ZYNSimZcA@mail.gmail.com>
Subject: Re: [PATCH 4/7] [RFC] enable L1_WRITETHROUGH mode for BG/P
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 5:43 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Wed, May 18, 2011 at 04:24:52PM -0500, Eric Van Hensbergen wrote:
>>
>>+config L1_WRITETHROUGH
>>+      bool "Blue Gene/P enabled writethrough mode"
>>+      depends on BGP
>>+      default y
>
> You add this config option here, named generically, but then make it
> depend on BGP.  It sees it should be named BGP_L1_WRITETHROUGH, and then
> just selected by the BGP platform.  But then....
>
>> endmenu
>>diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
>>index 111138c..3a3c711 100644
>>--- a/arch/powerpc/platforms/Kconfig.cputype
>>+++ b/arch/powerpc/platforms/Kconfig.cputype
>>@@ -329,9 +329,13 @@ config NOT_COHERENT_CACHE
>>       bool
>>       depends on 4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON
>>       default n if PPC_47x
>>+      default n if BGP
>>       default y
>>
>> config CHECK_CACHE_COHERENCY
>>       bool
>>
>>+config L1_WRITETHROUGH
>>+      bool
>
> You add an identical option down here.  Confused.
>

Yeah, this was copied from the original patches and it confused me as
well, but I had never
modified Kconfig.cputype before so I wasn't sure if there were some
weird rules.  I'm happy
to remove the vestigial one and make the changes you suggest to make
the naming BGP
specific.

         -eric
