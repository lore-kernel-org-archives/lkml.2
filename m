Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2A0VTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:19:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:37444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2A0VTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:19:52 -0500
Message-ID: <1327699182.2446.177.camel@twins>
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2012 22:19:42 +0100
In-Reply-To: <4F231256.8080905@linux.vnet.ibm.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-6-git-send-email-jolsa@redhat.com>
	 <4F231256.8080905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 13:08 -0800, Corey Ashford wrote:
> s an example, the IBM PowerEN processor has roughly 20 different PMU's
> on it.  Some of those PMU's are quite complex and divide their events up
> into subsets, each with different fields.  For example, some events may
> have a PID matching field, and others may have an bus number matching
> field, or matching mode field, etc.  The fields are different widths,
> and may overlap in the config/1/2 space.
> 
> It seems that there are two approaches you could take:
> 
> 1) Keep your format, but allow the fields to overlap in the bit space.
> For example:
> 
>   "/sys/...<dev>/format/event" contains "config:0-7"
>   "/sys/...<dev>/format/pidmatch" contains "config:8-15"
>   "/sys/...<dev>/format/busmatch"   contains "config:8-13"
> 
> Note that busmatch overlaps pidmatch
> 
> 2) Create event groups that have their overlapping config space
> separated out:
> 
>   "/sys/...<dev>/format/event" contains "config:0-7"
> 
>   "/sys/...<dev>.1/format/pidmatch" contains "config:8-15"
> 
>   "/sys/...<dev>.2/format/busmatch"   contains "config:8-13"
> 
> 
> Notice the .1 and .2 on the <dev>.
> 
> This might help the user understand which fields go together.  I'm not
> sold on the .1 syntax... you could do it as <dev>.<event-group-name>/ or
> <dev>/<event-group-name>/... or whatever seems to make the most sense
> and is relatively easy to implement and use. 

Why try and stuff those 20 in a single driver? Have 20 drivers and each
their own format/ hierarchy.
