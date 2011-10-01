Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1JATiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:38:46 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41750 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab1JATil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:38:41 -0400
Date: Sat, 1 Oct 2011 21:36:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com
Subject: Re: [PATCH 4/8] staging: et131x: Add pci suspend & resume functions
Message-ID: <20111001193650.GA14434@electric-eye.fr.zoreil.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com> <1317464057-18231-4-git-send-email-mark.einon@gmail.com> <20111001110357.GA10696@electric-eye.fr.zoreil.com> <CANK3SE3eHbBwzE5ZQJVoQEzw1QEE0bTp8Uf=CRpQEvNMiztPtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANK3SE3eHbBwzE5ZQJVoQEzw1QEE0bTp8Uf=CRpQEvNMiztPtg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Einon <mark.einon@gmail.com> :
> On 1 October 2011 12:03, Francois Romieu <romieu@fr.zoreil.com> wrote:
[...]
> >> + ? ? err = et131x_open(netdev);
> >> + ? ? if (err) {
> >> + ? ? ? ? ? ? dev_err(&pdev->dev, "Can't resume interface!\n");
> >> + ? ? ? ? ? ? goto out;
> >> + ? ? }
> >
> > You can/should split et131x_{open/close} to remove this failure point.
> 
> Hi, thanks for the comments francois,
> I'm not quite sure what you mean here. Can you expand on your comment please?

Something like:

int et131x_open(struct net_device *netdev)
{
	add_timer(...)

	err = request_irq(...)
	if (err < 0)
		goto release_timer;

	et131x_start(...)

out:
	return err;

release_timer:
	blah;
	goto out;
}

Same thing with et131x_close / et131x_stop. You only use et131x_{start/stop}
for suspend/resume : one error path is gone away.

-- 
Ueimor
