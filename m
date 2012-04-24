Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2DXNjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:39:02 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43967 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2DXNjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:39:00 -0400
Date: Tue, 24 Apr 2012 15:38:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac.h: Add generic layers for describing a memory
 location
Message-ID: <20120424133855.GJ11559@aftab.osrc.amd.com>
References: <4F969FC4.9080307@redhat.com>
 <1335271799-6263-1-git-send-email-mchehab@redhat.com>
 <20120424130925.GD11559@aftab.osrc.amd.com>
 <4F96A901.6070100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96A901.6070100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:22:09AM -0300, Mauro Carvalho Chehab wrote:
> The count of elements of a layer is the size of the layer. The Kernel macro
> that gets the number of elements of an array is called "ARRAY_SIZE", and not
> "ARRAY_N_ELEMS".
> 
> layers->size is the dimension of the layer. So, the term "size" fits better.
> For example, according with [1], size means:
> 	"the spatial dimensions, proportions, magnitude, or bulk of anything:
> 	 the size of a farm; the size of the fish you caught."
> 
> so, "size" fits better for a "dimension" measure.
> 
> I don't mind renaming it to n_elems, if this makes you happy.

Ok, let's do a simple comparison:

1. Imagine you look at ARRAY_SIZE(), what does it mean? Well, the size
of an array is pretty well defined to be the number of elements in it.
Easy.

2. Now imagine a struct member ->size. Out of context it could mean
anything, the size of something this struct represents, what the hell do
I know...

Now let's put it in context, layer->size: It could mean the size of the
layer in MB, it could mean how thick the layer is in meters, it could
... I can go on with these forever.

So your example with ARRAY_SIZE does not apply here.

If it is a badly explained struct and size is "maximum size" then this
means sh*t. So either leave it "size" but make sure to explain it
thoroughly what exactly size means here or change its name to something
more meaningful.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
