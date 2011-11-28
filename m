Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1K1Muv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:50:51 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:47432 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K1Muv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:50:51 -0500
Message-ID: <4ED3839E.6080702@grupopie.com>
Date: Mon, 28 Nov 2011 12:50:38 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nuno Santos <nsantos@edigma.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com> <4ECFBF56.4000002@edigma.com> <4ECFCAD5.5040606@grupopie.com> <4ECFD488.4060805@edigma.com> <4ECFDA1D.3090303@grupopie.com> <4ED35E52.5010008@edigma.com>
In-Reply-To: <4ED35E52.5010008@edigma.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nuno Santos wrote:
> Ok, understood!
> 
> Just one more question. To do this, do I need to change the data type
> from double to int?

You shouldn't have any "double" declarations on kernel code or the
compiler might start using floating point instructions to handle it.

Things that the compiler can work out at compile time are probably ok,
like converting constants:

#define FIXED(a)   (s32)((a) * 65536.0)

fixed = FIXED(1.25);

In this case compiler should make all the calculations at compile time
and replace the macro "FIXED(1.25)" with the integer 81920.

-- 
Paulo Marques - www.grupopie.com

"Don't worry, you'll be fine; I saw it work in a cartoon once..."
