Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1HBIiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:38:23 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:33242 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1HBIiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:38:16 -0400
Subject: Re: [patch v2 04/10] kdump: Trigger kdump via panic notifier chain
 on s390
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110801204114.GJ3805@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125808.028895659@linux.vnet.ibm.com>
	 <20110801204114.GJ3805@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 02 Aug 2011 10:37:59 +0200
Message-ID: <1312274279.4881.18.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Mon, 2011-08-01 at 16:41 -0400, Vivek Goyal wrote:
> On Wed, Jul 27, 2011 at 02:55:08PM +0200, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > On s390 we have the possibility to configure actions that are executed in
> > case of a kernel panic. E.g. it is possible to automatically trigger an s390
> > stand-alone dump. The actions are called via a panic notifier.  We also want
> > to trigger kdump via the notifier call chain. Therefore this patch disables
> > for s390 the direct kdump invocation in the panic() function.
> 
> Doesn't this reduce the reliability of the operation as you are assuming
> that panic notifier list is fine and not corrupted.

Yes, this is correct. We have to rely that the notifier list is fine.
Probably there is still room for improvement here.

> There might be other generic notifiers registerd on panic notifier list
> too. So in your case, are there multiple subsystem registering for panic
> notifiers? If not, why not call crash_kexec() directly. Are there any
> other actions you want to take on panic then calling crash_kexec()?

We have added the panic notifier in the past in order to be able to
configure the action that should be done in case of panic using our
shutdown actions infrastructure. We can configure the action using sysfs
and we are able to configure that a stand-alone dump should be started
as action for panic.

Now with the two stage dump approach we would like to keep the
possibility to trigger a stand-alone dump even if kdump is installed.
The stand-alone dumper will be started in case of a kernel panic and
then the procedure we discussed will happen: Jump into kdump and if
program check occurs do stand-alone dump as backup.

Michael

