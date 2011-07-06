Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1GFROy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:14:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:33372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GFROx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:14:53 -0400
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110706171015.GA13869@elte.hu>
References: <20110703150430.GV4590@erda.amd.com>
	 <1309716271.3282.6.camel@twins> <20110704175927.GZ4590@erda.amd.com>
	 <1309855905.3282.42.camel@twins> <20110705091252.GA5725@elte.hu>
	 <20110706165357.GG4590@erda.amd.com>  <20110706171015.GA13869@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Jul 2011 19:14:41 +0200
Message-ID: <1309972481.3282.319.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 19:10 +0200, Ingo Molnar wrote:
> 
> I think Peter suggested it that an open() done in /sys should give us 
> a handle to a given event? 

No, more like the open of a sysfs file could also grab a refcount on the
module. All it would take is a custom open/close method for sysfs files.
Now I have no clue how to do that, but that's another issue.

Also, I really don't see the point. With modular PMUs there's always
races against unload, just don't do that or live with it.


