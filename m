Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087Ab2CNNQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 09:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760970Ab2CNNQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 09:16:16 -0400
Message-ID: <4F609A15.5020902@redhat.com>
Date: Wed, 14 Mar 2012 15:16:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Wen Congyang <wency@cn.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <4F606DCC.3020908@redhat.com> <4F60726E.3090807@cn.fujitsu.com> <4F607325.6050607@redhat.com> <20120314104608.GU2304@redhat.com> <4F607789.4010109@redhat.com> <4F607CE4.2060809@cn.fujitsu.com> <4F609822.7050502@redhat.com> <20120314131415.GB2304@redhat.com>
In-Reply-To: <20120314131415.GB2304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 03:14 PM, Gleb Natapov wrote:
> On Wed, Mar 14, 2012 at 03:07:46PM +0200, Avi Kivity wrote:
> > On 03/14/2012 01:11 PM, Wen Congyang wrote:
> > > > 
> > > > I don't think we want to use the driver.  Instead, have a small piece of
> > > > code that resets the device and pushes out a string (the panic message?)
> > > > without any interrupts etc.
> > > > 
> > > > It's still going to be less reliable than a hypercall, I agree.
> > >
> > > Do you still want to use complicated and less reliable way?
> > 
> > Are you willing to try it out and see how complicated it really is?
> > 
> > While it's more complicated, it's also more flexible.  You can
> > communicate the panic message, whether the guest is attempting a kdump
> > and its own recovery or whether it wants the host to do it, etc., you
> > can communicate less severe failures like oopses.
> > 
> hypercall can take arguments to achieve the same.

It has to be designed in advance; and every time we notice something's
missing we have to update the host kernel.

> > > I think the other ones prefer to touch the hypervisor.
> > 
> > I understand the sentiment.  Your patches are simple and easy.  But my
> > feeling is that the kernel has become too complicated already and I'm
> > looking for ways to limit changes.
> > 
> Using virtio-serial will not reduce kernel complexity. Quite contrary
> since code that will use virtio-serial will be more complicated.

The host kernel is unmodified though.

-- 
error compiling committee.c: too many arguments to function

