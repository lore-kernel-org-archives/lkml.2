Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2FLMez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2FLMex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:34:53 -0400
Date: Tue, 12 Jun 2012 09:35:04 -0300
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 3/3] deal with guest panicked event
Message-ID: <20120612093504.1f7e24f1@doriath.home>
In-Reply-To: <4FD6E7E9.4090408@cn.fujitsu.com>
References: <4FB9E4CE.8060709@cn.fujitsu.com>
	<4FB9E5CB.2020208@cn.fujitsu.com>
	<20120530162314.1e9e4d3c@doriath.home>
	<4FD6E7E9.4090408@cn.fujitsu.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 14:55:37 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> >> +static void panicked_perform_action(void)
> >> +{
> >> +    switch(panicked_action) {
> >> +    case PANICKED_REPORT:
> >> +        panicked_mon_event("report");
> >> +        break;
> >> +
> >> +    case PANICKED_PAUSE:
> >> +        panicked_mon_event("pause");
> >> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> >> +        break;
> >> +
> >> +    case PANICKED_QUIT:
> >> +        panicked_mon_event("quit");
> >> +        exit(0);
> >> +        break;
> >> +    }
> > 
> > Having the data argument is not needed/wanted. The mngt app can guess it if it
> > needs to know it, but I think it doesn't want to.
> 
> Libvirt will do something when the kernel is panicked, so it should know the action
> in qemu side.

But the action will be set by libvirt itself, no?
