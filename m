Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331Ab2COLbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:31:45 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42584 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab2COLbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:31:43 -0400
Date: Thu, 15 Mar 2012 12:31:15 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120315113115.GA32149@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
 <4F61496D.8030000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F61496D.8030000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:44:13PM -0300, Mauro Carvalho Chehab wrote:
> As I said, that is easy to implement. The hard part would be what to do with
> the per-csrow/per-branch error counters that exist currently at EDAC.
> 
> From my side, I'm OK to remove them, but, as I said before, existing user tools
> use them,

What are you talking about? Those per-rank counters should be the same
as the per-csrow ch0 and ch1 counters...

> especially because UE errors aren't per-rank/per-dimm on the
> typical case (128 bits cacheline).

It depends - if the 128 bit word comes from a single DIMM (unganged
mode) then you have a per-rank UE.

> Of course, the EDAC logic could increment multiple UE error counters
> in such case, (meaning that an error happened on either one of the
> affected DIMMs/Ranks) but this is a different behavior than the
> current API.

Well, the API should be changed to accomodate such configurations.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
