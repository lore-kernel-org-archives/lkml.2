Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0LJUzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:55:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:56768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0LJUzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:55:02 -0500
Message-ID: <4D029389.1050402@kernel.org>
Date: Fri, 10 Dec 2010 21:54:33 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-14-git-send-email-tj@kernel.org> <alpine.LFD.2.00.1012092230010.2653@localhost6.localdomain6> <4D029162.1040205@kernel.org>
In-Reply-To: <4D029162.1040205@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 20:54:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 09:45 PM, Tejun Heo wrote:
> I can change srat_detect_node() and nearby_node() to index by cpu but
> as I have no idea what kind of broken configurations this is supposed
> to deal with, I'm concerned that this may lead to different outcome by
> walking the table in a different order.  I can implement an apicid ->
> numa node mapping function for this but this is something which is
> inherently ugly, so maybe it's best to leave it ugly.

Oh, right, another problem.  It's possible that apicid <-> numa
mapping exists when apicid <-> cpu doesn't.  Again, this is a corner
case which might not matter but I have no idea what kind of brokeness
is being worked around and it would also be difficult to test whether
the change is okay.

If someone can tell me that this workaround can go away, it would be
awesome.

-- 
tejun
