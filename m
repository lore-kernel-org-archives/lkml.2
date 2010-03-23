Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0CWKOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0CWKOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:14:07 -0400
Message-ID: <4BA89430.7060404@redhat.com>
Date: Tue, 23 Mar 2010 11:13:04 +0100
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws>
In-Reply-To: <4BA7E9D9.5060800@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.03.2010 23:06, schrieb Anthony Liguori:
> On 03/22/2010 02:47 PM, Avi Kivity wrote:
>> Having qemu enumerate guests one way or another is not a good idea IMO 
>> since it is focused on one guest and doesn't have a system-wide entity.
> 
> There always needs to be a system wide entity.  There are two ways to 
> enumerate instances from that system wide entity.  You can centralize 
> the creation of instances and there by maintain an list of current 
> instances.  You can also allow instances to be created in a 
> decentralized manner and provide a standard mechanism for instances to 
> register themselves with the system wide entity.
> 
> IOW, it's the difference between asking libvirtd to exec(qemu) vs 
> allowing a user to exec(qemu) and having qemu connect to a well known 
> unix domain socket for libvirt to tell libvirtd that it exists.

I think the latter is exactly what I would want for myself. I do see the
advantages of having a central instance, but I really don't want to
bother with libvirt configuration files or even GUIs just to get an
ad-hoc VM up when I can simply run "qemu -hda hd.img -m 1024". Let alone
that I usually want to have full control over qemu, including monitor
access and small details available as command line options.

I know that I'm not the average user with these requirements, but still
I am one user and do have these requirements. If I could just install
libvirt, continue using qemu as I always did and libvirt picked my VMs
up for things like global enumeration, that would be more or less the
optimal thing for me.

Kevin
