Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab0KPNNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:13:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240Ab0KPNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:13:07 -0500
Message-ID: <4CE2834F.9080509@vlnb.net>
Date: Tue, 16 Nov 2010 16:12:47 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>,
        Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>	 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>	 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net>	 <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net>	 <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com>	 <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>	 <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com> <1289852370.22107.104.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1289852370.22107.104.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:FuVcCmSihII+eZOWHjXfkUIuNqbTWQOKy2SrVX/cA0P
 K/8FkJNHBa0pJ6tVOV2g2lHwbxw2M3/0mp/hbQplIr9z/VauM7
 fi+WGFpIyh20TXtSP7P+rc5/OmC/qsBJkGHWBEq4BkJNTboHG/
 Jd1TbLYeCBX+2Hyjw+BNa8EIjss96/z8QWKzQlHpOlj1myvxBz
 V8egZ5l3NiyvidHlBYFNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger, on 11/15/2010 11:19 PM wrote:
>> I think that Vlad has already explained several times why ConfigFS is
>> not suited for the needs of a storage target: a storage target must
>> not only be able to accept configuration information from userspace
>> but must also be able to create new directories and file nodes itself.
>> See e.g. this message from October 6:
>> http://kerneltrap.org/mailarchive/linux-kernel/2010/10/6/4628664.
> 
> Sorry, but this post explains nothing but a single misguided and
> uninformed opinion, with no hard facts on the actual usage of a native
> configfs control plane within target mode infrastructure.  

What is "misguided and uninformed opinion"? That you can't with ConfigFS
serve real life needs for target driver developers and can't create
targets for hardware target ports from withing the kernel and instead
enforce users to clumsy workarounds to somehow magically know their
names to manually perform "mkdir target_name"?

The same problem exists for all other objects where you need to create
ConfigFS entries (directories), like for per-session/per-initiator
statistics or default ACLs.

ConfigFS is just too simple to serve real life needs of a SCSI target
subsystem.

Vlad
