Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0F1OQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:16:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38019 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0F1OQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:16:21 -0400
Date: Mon, 28 Jun 2010 16:16:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-ID: <20100628141615.GA7608@basil.fritz.box>
References: <87d3vfeage.fsf@basil.nowhere.org>
 <4C24C279.3050206@austin.ibm.com>
 <20100628110658.387B.A69D9226@jp.fujitsu.com>
 <m14ognkd26.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ognkd26.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a prototype patch sitting around somewhere.  I think ultimately
> it makes sense to do something like extN's htree directory structure
> in sysfs.  I wanted to get the tagged sysfs support in before I worked
> on scalability because that slightly changes the requirements.
> 
> Improving the scalability here is certainly worth doing, but I am slightly
> concerned there is something else algorithmically wrong if this is still
> going to take 33 minutes to boot with 2TB.

I'm don't think thousands of entries in sysfs is really a good idea. Even if you fix
the the insert algorithm issues a simple ls will still be very slow and there
will be likely other issues too. And nobody can claim that's a good interface.

This really needs a better a interface.
e.g. add some wildcard entry as it was earlier proposed.
and only generate the wildcard when some threshold is exceeded.

-Andi
