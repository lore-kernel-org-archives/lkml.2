Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2DDF5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 01:57:19 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:63046 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2DDF5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 01:57:18 -0400
Message-ID: <20347.58038.604528.388765@ipc1.ka-ro>
Date: Wed, 4 Apr 2012 07:57:10 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] devicetree: pull evaluation of of_address_to_resource() out of loop in of_dev_lookup()
In-Reply-To: <20120403235434.A536C3E03F3@localhost>
References: <1333457308-6005-1-git-send-email-LW@KARO-electronics.de>
	<20120403235434.A536C3E03F3@localhost>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Grant Likely writes:
> On Tue,  3 Apr 2012 14:48:28 +0200, Lothar Waßmann <LW@KARO-electronics.de> wrote:
> > The result of_address_to_resource(np, 0, &res) is independent from the
> > for (; lookup->compatible != NULL; lookup++) {
> > }
> > loop evaluation. Evaluate it once before entering the loop.
> > 
> > Also add a space between 'for' keyword and parens.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> 
> What is the reason for this patch?  The error path may be slightly
> less efficient in the failure case, but it isn't incorrect.
> 
What's not correct? If of_address_to_resource() yields a non-zero
result, the function will never reach the 'return lookup' inside the
loop but only the 'return NULL' at the end of the function. Thus it is
vain to re-evaluate of_address_to_resource() in every loop.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
