Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab2JESjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:39:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58890 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab2JESjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <506E313B.5010303@jp.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
 <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com> <CAHGf_=rLMsmAxR5hrDVXjkHAxmupVrmtqE3iq2qu=O9Prp4nSg@mail.gmail.com>
 <5064EA5A.3080905@jp.fujitsu.com> <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com>
 <5064FDCA.1020504@jp.fujitsu.com> <CAHGf_=r+oz0GS137e81EySbN-3KVmQisF8sySiCUYUas1RZLtQ@mail.gmail.com>
 <5065740A.2000502@jp.fujitsu.com> <CAHGf_=o_FLsEULK3s1+zD-A0FL5QvKnX542Lz4vCwVVV2fYNRw@mail.gmail.com>
 <50693E30.3010006@jp.fujitsu.com> <CAHGf_=qZVe_KfThZa5yEm+4w3MMREs1xqya5HmKWsWjyTcjkzA@mail.gmail.com>
 <506E313B.5010303@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 5 Oct 2012 14:39:22 -0400
X-Google-Sender-Auth: 3CEqqzw98Uh6LHuFp4hofh2pycw
Message-ID: <CAHGf_=qn4m6x95h5uV6jXibc0RmTH-1ZC17vSUTyTTXktfd23g@mail.gmail.com>
Subject: Re: [PATCH 2/4] memory-hotplug: add node_device_release
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: wency@cn.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have the reason to have to fill the node struct with 0 by memset.
> The node is a part of node struct array (node_devices[]).
> If we add empty release function for suppressing warning,
> some data remains in the node struct after hot removing memory.
> So if we re-hot adds the memory, the node struct is reused by
> register_onde_node(). But the node struct has some data, because
> it was not initialized with 0. As a result, more waning is shown
> by the remained data at hot addinig memory as follows:

Even though you call memset(0) at offline. It doesn't guarantee the memory
keep 0 until online. E.g. physical memory exchange during offline, bit
corruption
by cosmic ray, etc. So, you should fill zero at online phase explicitly if need.

The basic hotplug design is: you should forget everything at offline
and you shouldn't
assume any initialized data at online.

Thanks.
