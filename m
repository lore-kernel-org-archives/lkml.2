Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2BQS1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:27:46 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:46270 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752218Ab2BQS1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:27:44 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F3E9C1B.5040404@freescale.com>
Date: Fri, 17 Feb 2012 12:27:39 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com> <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de> <4F3D57E3.7020503@redhat.com> <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de> <4F3D5B35.4000606@redhat.com> <4F3D6A0E.4080705@freescale.com> <016BCCE1-3E2C-4812-AA4D-2DC9D27CB457@suse.de>
In-Reply-To: <016BCCE1-3E2C-4812-AA4D-2DC9D27CB457@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 06:23 PM, Alexander Graf wrote:
> On 16.02.2012, at 21:41, Scott Wood wrote:
>> And yes, we do have fancier hardware coming fairly soon for which this
>> breaks (TLB0 entries can be loaded without host involvement, as long as
>> there's a translation from guest physical to physical in a separate
>> hardware table).  It'd be reasonable to ignore TLB0 for migration (treat
>> it as invalidated), but not for debug since that may be where the
>> translation we're interested in resides.
> 
> Could we maybe add an ioctl that forces kvm to read out the current tlb0 contents and push them to memory? How slow would that be?

Yes, I was thinking something like that.  We'd just have to remove (make
conditional on MMU type) the statement that this is synchronized
implicitly on return from vcpu_run.

Performance shouldn't be a problem -- we'd only need to sync once and
then can do all the repeated debug accesses we want.  So should be no
need to mess around with partial sync.

-Scott

