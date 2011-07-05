Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1GESQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:16:51 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:47558 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1GESQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:16:50 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArpiAApUE05V5q1MPGdsb2JhbABTiQqefgsBAQEBNzKIegLCOQ6GKASXPIsy
X-IronPort-AV: E=Sophos;i="4.65,481,1304287200"; 
   d="scan'208";a="27046019"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Jul 2011 20:18:43 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dmitry.torokhov@gmail.com, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 05/12] Input: synaptics - process button bits in AGM
 packets
Message-ID: <20110705181843.GA29296@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-6-git-send-email-djkurtz@chromium.org>
 <20110704212404.GC23915@polaris.bitmath.org>
 <CAGS+omALkYhzS+rvWhsXCwuWMHWpJJJ7j9Z9cBQ1Gem5HnH_fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omALkYhzS+rvWhsXCwuWMHWpJJJ7j9Z9cBQ1Gem5HnH_fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Any particular reason to move these and leave them unassigned for clickpads?
> 
> Yes.  The current implementation incorrectly parses the x, y, z of AGM
> packets and assigns junk values to the corresponding fields of the
> temporary hw struct.  Luckily, this struct is then just discarded upon
> return (synaptics_parse_hw_state returns 1 causing
> synaptics_process_packet() to exit immediately).
>
> Instead, this patch parses the w value first to determine the packet
> type, and then use this packet type information to parse the remaining
> position and pressure fields correctly...
> 
> Notice that the "else" clause is taken for SGM packets (w != 2), even
> for clickpads.

Functionally, there is no difference between assigning new junk or
reusing old junk, hence that part of the patch is not strictly needed.

Thanks,
Henrik
