Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab0HPVVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:21:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54737 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab0HPVVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:21:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C69ABE6.6030309@s5r6.in-berlin.de>
Date: Mon, 16 Aug 2010 23:21:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] firewire: sbp2: fix stall with "Unsolicited response"
References: <tkrat.330c42bb8ceb6a7a@s5r6.in-berlin.de> <tkrat.d1f4cde2efe6d756@s5r6.in-berlin.de>
In-Reply-To: <tkrat.d1f4cde2efe6d756@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> The stalls happen during heavy or moderate disk traffic in periods that
> are a multiple of 5 minutes, roughly twice per hour.  They are caused
> by the target responding too late to an ORB_Pointer register write
[and subsequent SCSI error handling.]
> So let's just ignore RCODE_CANCELLED in the transaction callback and
> wait for the target to complete the ORB nevertheless.

PS:  This is not only about the stalls.  It is also to prevent memory
corruption that may happen when the target writes to SCSI request
buffers after they were unmapped and freed, although this does not
appear likely to me.
-- 
Stefan Richter
-=====-==-=- =--- =----
http://arcgraph.de/sr/
