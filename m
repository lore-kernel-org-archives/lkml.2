Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0LJHCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:02:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0LJHCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zgu/m6I2dsQhhLZAhNbv2u3CJT4VjRTAqri0xKoYmpho8LbxlIXd2s6wqhSXJbXMIz
         zc9Tnj86jZ5KCJIJVutLxENee17Lr31CxGfkGmZmSPDfb/RBGGR9sQwGgcq6tEDnrkGP
         LqhEammG8kKpQIxFQSjkaV0Mw3T9fjZhPiphg=
Subject: Re: [PATCH v2 3/4] kthread: NUMA aware kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <20101209223210.acd540de.akpm@linux-foundation.org>
References: <1290972833.29196.90.camel@edumazet-laptop>
	 <20101128224024.GA12300@basil.fritz.box>
	 <1290984712.29196.100.camel@edumazet-laptop>
	 <20101128230146.GB12300@basil.fritz.box>
	 <1290987424.29196.128.camel@edumazet-laptop>
	 <20101129090510.GA15763@basil.fritz.box>
	 <1291023532.3435.29.camel@edumazet-laptop>
	 <1291043695.3435.980.camel@edumazet-laptop>
	 <20101209164438.fae1ba4c.akpm@linux-foundation.org>
	 <1291960798.2803.18.camel@edumazet-laptop>
	 <20101209223210.acd540de.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 08:02:41 +0100
Message-ID: <1291964561.2803.25.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 décembre 2010 à 22:32 -0800, Andrew Morton a écrit :

> but but but.  The name "kthread_create_on_cpu" sucks.  It's plain wrong.

Okay you are right Andrew ;) I dont have better idea for the moment.

Note that all callers I converted really create one kthread per cpu, not
per node. They didnt care of node affinity, only me :)

kthread_create_on_node() seems misleading to me (some cpus run on
memoryless nodes)



