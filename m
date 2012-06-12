Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2FLMlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:41:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2FLMlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:41:04 -0400
Date: Tue, 12 Jun 2012 13:40:45 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 3/3] deal with guest panicked event
Message-ID: <20120612124045.GK10153@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4FB9E4CE.8060709@cn.fujitsu.com>
 <4FB9E5CB.2020208@cn.fujitsu.com>
 <20120530162314.1e9e4d3c@doriath.home>
 <4FD6E7E9.4090408@cn.fujitsu.com>
 <20120612093504.1f7e24f1@doriath.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120612093504.1f7e24f1@doriath.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:35:04AM -0300, Luiz Capitulino wrote:
> On Tue, 12 Jun 2012 14:55:37 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
> > >> +static void panicked_perform_action(void)
> > >> +{
> > >> +    switch(panicked_action) {
> > >> +    case PANICKED_REPORT:
> > >> +        panicked_mon_event("report");
> > >> +        break;
> > >> +
> > >> +    case PANICKED_PAUSE:
> > >> +        panicked_mon_event("pause");
> > >> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> > >> +        break;
> > >> +
> > >> +    case PANICKED_QUIT:
> > >> +        panicked_mon_event("quit");
> > >> +        exit(0);
> > >> +        break;
> > >> +    }
> > > 
> > > Having the data argument is not needed/wanted. The mngt app can guess it if it
> > > needs to know it, but I think it doesn't want to.
> > 
> > Libvirt will do something when the kernel is panicked, so it should know the action
> > in qemu side.
> 
> But the action will be set by libvirt itself, no?

Sure, but the whole world isn't libvirt. If the process listening to the
monitor is not the same as the process which launched the VM, then I
think including the action is worthwhile. Besides, the way Wen has done
this is identical to what we already do with QEVENT_WATCHDOG and I think
it is desirable to keep consistency here.

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
