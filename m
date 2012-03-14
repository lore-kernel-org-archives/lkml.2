Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2CNWbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:31:32 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40140 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2CNWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:31:29 -0400
Date: Wed, 14 Mar 2012 23:31:02 +0100
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120314223102.GA27602@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314204355.GA10187@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 01:43:55PM -0700, Greg KH wrote:
> > He thinks that a multi-layer struct should be created inside that directory
> > (it could have 2 or 3 levels of directories, depending on how the memory is
> > organized at the memory controller), instead of having a large number of files
> > there.
> 
> Why create subdirs?  If those subdirectories are not real devices,
> showing a real hierarchy, then do not create them as userspace will get
> very confused very quickly.

Why, IMO, we agreed on the following layout

rank0/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
|-- CE
|-- UE
`-- dimm_size

with CE being the correctable errors counter and UE be optional and only
present when it makes sense for the hardware.

This is not multi-layered, it is very easy to implement and mirrors all
possible memory controllers from the point of view of the single DIMM.
no? Or am I missing something...?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
