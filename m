Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab1CDP6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:58:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1CDP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:58:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH v10 1/1] PRUSS UIO driver support
Date: Fri, 4 Mar 2011 16:58:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com> <20110304142028.GD28175@local> <B85A65D85D7EB246BE421B3FB0FBB593024C009039@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C009039@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041658.05655.arnd@arndb.de>
X-Provags-ID: V02:K0:K8fDNVH1U+i43IskLV4bZf3iNN6I3AyFEUwR0d83yR8
 k57C6//JgJvqoYqPQjTPfU3gpjiwb1KG8z6sblk7DrlwOn5Mx0
 OX1O/qSyQKVd+f1CqiWSF5D/qDHL7hrAB0IeiQZSU8+Fp9OtAt
 pIgW92sg5LuZyqPNDOvtCr3/UsNA1N7gs+GTuV6qQnBatV5VQY
 np+1ttgmFXcbB+aG1nLvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011, Nori, Sekhar wrote:
> On Fri, Mar 04, 2011 at 19:50:28, Hans J. Koch wrote:
> > On Fri, Mar 04, 2011 at 10:12:52AM +0530, Pratheesh Gangadhar wrote:
> > > diff --git a/include/linux/uio_pruss.h b/include/linux/uio_pruss.h
> > > new file mode 100644
> > > index 0000000..8c9b2c9
> > > --- /dev/null
> > > +++ b/include/linux/uio_pruss.h
> > 
> > That should go to arch/arm/mach-davinci/include/mach/
> > and not to the top level include/linux/ directory.
> 
> It was put in here because this driver
> will be used across two ARM architectures
> (DaVinci and OMAP). Although it won't be used
> outside of ARM at least in near future.

I think include/linux/ is fine for this, and arch/arm/include/asm would
be ok as well. You might want to have only a single pruss header
file that defines all the platform data for the child drivers, though.

Ideally, you would of course not need the header at all. This will
be possible with the move to a flat device tree, where you can store the
offset as a property of the device

Another alternative would be to move it to a resource of the platform
device.

	Arnd
