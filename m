Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1EDNpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:45:10 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:33660 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1EDNpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:45:08 -0400
Message-ID: <4DC158E5.50908@ladisch.de>
Date: Wed, 04 May 2011 15:47:17 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Eibach, Dirk" <Eibach@gdsys.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: msleep() an load average
References: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de>
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eibach, Dirk wrote:
> while(1) msleep_interruptible(1000);
> 
> Is this code really any better?

You should handle signals, probably by blocking any that you're not
interested in, and exiting on any fatal one.

Anyway, polling is bad; this code forces the CPU to wake up once
per second.  What is your thread _actually_ waiting for?
(I guess it has more code than what you wrote?)


Regards,
Clemens
