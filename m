Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936138Ab2KAV70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:59:26 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25250 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992489Ab2KAV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:59:23 -0400
Message-ID: <1351806702.19172.104.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 3/3] Improve container_notify_cb() to support
 container hot-remove.
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, ZhangRui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, bhelgaas@google.com,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Nov 2012 15:51:42 -0600
In-Reply-To: <11976302.Ya3MGGIAsU@vostro.rjw.lan>
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1748725.QBg5LLmPOx@vostro.rjw.lan>
	 <CAE9FiQV0gAJabpcoSHhTYq19m-YmaC0O6HH_dFKXUTuvUMG4Fg@mail.gmail.com>
	 <11976302.Ya3MGGIAsU@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >> Hi Yinghai,
> > >>
> > >> Per the following thread, the code seems to be written in this way to
> > >> allocate a separate lock_class_key for each work queue.  It should have
> > >> had some comment to explain this, though.
> > >>
> > >> https://lkml.org/lkml/2009/12/13/304
> > >
> > > The code has evolved since then, however, so that it doesn't make sense
> > > any more.
> > >
> > 
> > oh, no, that commit should not be reverted. instead we should add some
> > comment for it...
> > 
> > that mean : three path, will have three separated static lock dep key
> > from every INIT_WORK.
> 
> I see.
> 
> OK, I'll drop the patch removing it.
> 
> What about the following comment:
> 
> "To prevent lockdep from complaining unnecessarily, make sure that there
>  is a different static lockdep key created for each workqueue by using
>  INIT_WORK for each of them separately."

Looks good to me.

Thanks,
-Toshi


> 
> Thanks,
> Rafael
> 
> 


