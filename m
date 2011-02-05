Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1BEUjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:39:11 -0500
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:39259 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1BEUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:39:09 -0500
Message-ID: <4D4DB56B.9020806@hardwarefreak.com>
Date: Sat, 05 Feb 2011 14:39:07 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Jean Gobin <jf@gobinjf.be>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <1296934967.2599.2.camel@jeff-ubuntu> <alpine.DEB.2.00.1102051510080.8518@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1102051510080.8518@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz put forth on 2/5/2011 2:18 PM:

> Everything > 1 Gbyte/sec but when you use the network, 250MiB/s, it does not
> make sense.

Did you try launching 4 simultaneous cp operations over nfs to get to 1.2 GB/s?
 I've witnessed single stream copy performance with Samba being less than
maximum due to Samba limitations.  Running multiple copy ops in parallel then
usually saturates the pipe.

I'm thinking you may have a single threaded process involved that's eating all
of one core, at which point there is no scalability left for that operation.

-- 
Stan
