Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1JMTPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:15:05 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39783 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1JMTPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:15:02 -0400
Date: Thu, 13 Oct 2011 21:14:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?= <niso@kth.se>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i7core_edac: fix erroneous size of static array
Message-ID: <20111013191448.GD3064@aftab>
References: <1318530294-6829-1-git-send-email-niso@kth.se>
 <20111013185656.GC3064@aftab>
 <987664A83D2D224EAE907B061CE93D5301EE87A060@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EE87A060@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 03:03:20PM -0400, Luck, Tony wrote:
> > -	static int cols[8] = {
> > +	static int cols[4] = {
> 
> Why are these arrays "static"? Does that generate better code than
> dynamic initialization?

They look like lookup arrays for count of things based on bit settings
and as such they should be static because they don't ... change :). If
they were dynamic, then inlining them in every function callsite would
be not cool.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
