Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2AaDmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:42:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57458 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2AaDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:42:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
	<20120130221059.26ab5edf@pyramind.ukuu.org.uk>
Date: Mon, 30 Jan 2012 19:45:10 -0800
In-Reply-To: <20120130221059.26ab5edf@pyramind.ukuu.org.uk> (Alan Cox's
	message of "Mon, 30 Jan 2012 22:10:59 +0000")
Message-ID: <m1mx94cz7d.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/TkiU/soGFqICadlKVTQTl+WOKPuGAI2M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Isn't there some other "proper" way of doing this in userspace, or is
>> this really the correct way?
>
> You can look at the S_IFMT bits and stuff however link count indicating
> number of subdirectories is a standard Unix thing and used by many quite
> mundane tools as an optimisation.

Those tools for a decade or better all know to treat nlink == 1 as the
case where the optimization does not apply.

On a traditional unix filesytem the most common place you will see nlink
== 1 is when the link count overflows.  extN with > 65536 subdirectories
as I recall.


Eric
