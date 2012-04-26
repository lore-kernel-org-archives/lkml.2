Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2DZO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:26:45 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54809 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab2DZO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:26:44 -0400
Date: Thu, 26 Apr 2012 16:26:37 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>
Subject: Re: [EDAC PATCH v13 1/7] edac: Create a dimm struct and move the
 labels into it
Message-ID: <20120426142637.GA2793@aftab.osrc.amd.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1334607133-30039-2-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:12:07PM -0300, Mauro Carvalho Chehab wrote:
> The way a DIMM is currently represented implies that they're
> linked into a per-csrow struct. However, some drivers don't see
> csrows, as they're ridden behind some chip like the AMB's
> on FBDIMM's, for example.
> 
> This forced drivers to fake^Wvirtualize a csrow struct, and to create
> a mess under csrow/channel original's concept.
> 
> Move the DIMM labels into a per-DIMM struct, and add there
> the real location of the socket, in terms of csrow/channel.
> Latter patches will modify the location to properly represent the
> memory architecture.
> 
> All other drivers will use a per-csrow type of location.
> Some of those drivers will require a latter conversion, as
> they also fake the csrows internally.
> 
> TODO: While this patch doesn't change the existing behavior, on
> csrows-based memory controllers, a csrow/channel pair points to a memory
> rank. There's a known bug at the EDAC core that allows having different
> labels for the same DIMM, if it has more than one rank. A latter patch
> is need to merge the several ranks for a DIMM into the same dimm_info
> struct, in order to avoid having different labels for the same DIMM.
> 
> The edac_mc_alloc() will now contain a per-dimm initialization loop that
> will be changed by latter patches in order to match other types of
> memory architectures.
> 
> Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
> Cc: "Arvind R." <arvino55@gmail.com>
> Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Reviewed-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
