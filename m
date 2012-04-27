Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984Ab2D0SFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:05:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760794Ab2D0SFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:05:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120427152323.GB2419@linux.vnet.ibm.com>
References: <CA+1xoqcPSCA+iNdMETZMhXpmGaVkC2ACCJZAt4CSBkaoVwVvGQ@mail.gmail.com>
 <20120427152323.GB2419@linux.vnet.ibm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 27 Apr 2012 20:05:15 +0200
Message-ID: <CA+1xoqc+283VNm6Ai7O9LCQk_12K6jpXUGKwKe7sTJff3cuX_w@mail.gmail.com>
Subject: Re: async pf: INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
To: paulmck@linux.vnet.ibm.com
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 5:23 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> On Thu, Apr 26, 2012 at 04:50:35PM +0200, Sasha Levin wrote:
> > Hi all.
> >
> > I got a "INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected"
> > warning
> > while running LTP inside a KVM guest using the recent -next kernel.
> >
> > It seems that it was initially originated from rcu_torture_rea(), but I
> > don't think that it's a problem with RCU itself (I'll cc. Paul just in
> > case). RCU torture was indeed configured to run during the testing.
>
> I might be missing something, but I don't see how RCU is involved in
> this one.

It happened due to a rcutorture thread:

[ 4248.579019] rcu_torture_rea/1615 [HC0[0]:SC0[0]:HE0:SE1] is trying
to acquire:
[ 4248.579019]  (pgd_lock){+.+...}, at: [<ffffffff81089476>] pgd_free+0x26/0xa0

rcutorture has never triggered anything on my tests up until now, and
is probably not responsible for the actual warning in this case, just
figured I should cc you in case I'm wrong :)
