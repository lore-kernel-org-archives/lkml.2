Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0F3Sm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:42:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16938 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0F3Sm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bkbYZmi1w2L7GIyIo8OZ87qtTnWKizjarZtXHaioYlUAAFAZX2RlMJ6BrZ0XtJ+uYm
         J9dv5/Qv0rdBtfaMFEcBfxquPJ2lBt5mnFveUuhQ22ySxq1J4uy3xVZp86Dz+5WQQQZl
         yrNeiybNHfH48/7plpoyS5w/GjhZJsp2wi8w0=
MIME-Version: 1.0
Date: Wed, 30 Jun 2010 14:42:53 -0400
Message-ID: <AANLkTimmIG6GF-hKBk7JsZpvZNEAj1Tlt4GrPXexN0_0@mail.gmail.com>
Subject: RE: [PATCH] VMware balloon: force compiling as a module
From: Chetan Loke <chetanloke@gmail.com>
To: dtor@vmware.com, pv-drivers@vmware.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, chetanloke@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
> Sent: June 28, 2010 7:01 PM
> VMware Tools installer requires the upstream driver to be compiled
> as a module in order to detect its presence and avoid installing
> our own version on top of it. To avoid surprises with 2 versions
> of the driver being installed and fighting with each other, let's
> force the driver to be compiled as a module unless user selects
> CONFIG_EMBEDDED.
>

>  config VMWARE_BALLOON
>  	tristate "VMware Balloon Driver"
> -	depends on X86
> +	depends on X86 && (EMBEDDED || m)

None of the following questions are related to this patch.

Q1)Does vmtools handle pvscsi correctly?

Q2)In case if a VM wants to be a good citizen, is there a way for a
guest to know about the balloon-event?

Q3)What if an app mlock's its memory resources and driver's have
pinned down their pages then how does inflation work?


regards
Chetan Loke
