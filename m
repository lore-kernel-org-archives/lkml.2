Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2CLO5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:57:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2CLO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:57:05 -0400
Date: Mon, 12 Mar 2012 09:57:01 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120312145701.GA12322@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120312142126.GA11969@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312142126.GA11969@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 02:21:26PM +0000, Matthew Garrett wrote:
> apple_bl probably needs some matching work to disable itself if there's 
> a gmux present? Otherwise, this looks good.

How do you suggest doing this? The tricky point is that the gmux object
can be present in ACPI when the gmux hardware isn't really present
(which is what the version check really does, verifies the hardware is
actually there). So apple_bl can't just look for the ACPI object; it
needs to either communicate with apple-gmux or duplicate some of its
logic.

We also have the problem of gmux_backlight versus acpi_video. On most
machines with a gmux the acpi_video backlight interface is present but
just doesn't work. This problem isn't just limited to Apples. I'm of the
opinion that we need a more generalized solution for arbitrating between
the backlight interfaces present on a given machine, but I haven't had a
chance to really think about what that would look like.

Seth

