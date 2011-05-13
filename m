Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab1EMNUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:20:32 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:51919 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab1EMNUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:20:30 -0400
Subject: Re: question about drivers/isdn/hisax/st5481_init.c
From: Ben Hutchings <bhutchings@solarflare.com>
To: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1105130748060.9190@ask.diku.dk>
References: <Pine.LNX.4.64.1105130748060.9190@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Fri, 13 May 2011 14:20:26 +0100
Message-ID: <1305292826.4065.443.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2011 13:20:29.0544 (UTC) FILETIME=[87928E80:01CC1170]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18132.005
X-TM-AS-Result: No--17.192300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 07:53 +0200, Julia Lawall wrote:
> The function probe_st5481 allocates an adapter value using kzalloc, adds 
> it to adapter_list, and then performs various initialization operations, 
> which may fail.  adapter_list is a static variable that is never otherwise 
> referenced in the file.  There is a list_del that removes the adapter from 
> the list in the function disconnect_st5481.  The presence of the adapter 
> on the list makes it possibly unsafe to free adapter in the failure cases.
> 
> Could the list just be removed, if it is not being used anywhere?
> 
> Or if the list should be kept because it is useful or it is planned to be 
> useful in the future, could the insertion into the list be moved to the 
> end of the function, after the potentially failing operations, so that 
> adapter can be freed when a failure occurs?

Some older drivers have these device lists hanging around from before
the device model has implemented.  If the list isn't being used now then
it's probably fine to remove.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

