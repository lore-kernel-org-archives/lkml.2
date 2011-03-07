Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1CGSuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:50:05 -0500
Received: from kroah.org ([198.145.64.141]:53052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1CGSuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:50:03 -0500
Date: Mon, 7 Mar 2011 10:48:00 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
Message-ID: <20110307184800.GA13355@kroah.com>
References: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTi=w=5L8tbjGDCgoRpjRXYrNxsfWaE2SL4XG9+pY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=w=5L8tbjGDCgoRpjRXYrNxsfWaE2SL4XG9+pY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:02:44PM +0200, Felipe Contreras wrote:
> On Mon, Dec 20, 2010 at 7:12 PM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
> > We need to protect not only the dmm_map list, but the individual
> > map_obj's, otherwise, we might be building the scatter-gather list with
> > garbage. So, use the existing proc_lock for that.
> >
> > I observed race conditions which caused kernel panics while running
> > stress tests. This patch fixes those.
> 
> I just heard that Tuomas Kulve is getting a lot of panics on Gumstix
> Overo. I propose we apply this patch on the stable tree ASAP, and if
> there's no better proposals, also on .38.

Um, I don't think you realize _how_ stable trees work, please go read
Documentation/stable_kernel_rules.txt to see how it is not possible to
take something into the stable releases before it goes to Linus's tree.

Sorry,

greg k-h
