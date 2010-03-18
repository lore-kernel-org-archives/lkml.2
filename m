Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0CRHRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 03:17:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0CRHRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 03:17:05 -0400
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100318071131.GC24062@Localhorst.asterix.local>
Date: Thu, 18 Mar 2010 08:17:01 +0100
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de>
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com> <4BA1504A.3090801@dieterries.net> <808FF008-53B9-4271-904C-117A24ADF18C@suse.de> <20100317224002.GA5156@Localhorst.asterix.local> <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de> <20100318071131.GC24062@Localhorst.asterix.local>
To: Dieter Ries <mail@dieterries.net>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18.03.2010, at 08:11, Dieter Ries wrote:

> On Wed, Mar 17, 2010 at 11:47:14PM +0100, Alexander Graf wrote:
>> It looks like one of your CPUs has EFER_SVME enabled on bootup already. I'm not aware of code clearing EFER, so if there's garbage in there on boot it stays there.
>> 
>> Could you please add the current CPU number to your printk? I bet it's always the same one.
> 
> [ 1300.393635] efer on CPU1 is d01
> [ 1300.393638] efer on CPU3 is d01
> [ 1300.393641] efer on CPU2 is d01
> [ 1300.393643] EFER_SVME is 1000
> [ 1300.393645] EFER_SVME is 1000
> [ 1300.393646] EFER_SVME is 1000
> [ 1300.393650] efer on CPU0 is 1d01
> [ 1300.393652] EFER_SVME is 1000
> [ 1300.393653] kvm: enabling virtualization on CPU0 failed
> 
> 
>> If that's the case I'd say you have a broken BIOS or bootloader.
> 
> You are right, it seems to be always cpu0. I'll check my BIOS and flash
> a newer version if available.

Please do. If that doesn't help ping me again. I'll write up a quirk patch then.


Alex