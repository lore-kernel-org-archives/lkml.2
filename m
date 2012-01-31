Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2AaEmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:42:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46237 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2AaEmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:42:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Damien Millescamps <damien.millescamps@6wind.com>
Subject: Re: [PATCH 22/29] sysctl: Stop requiring explicit management of sysctl directories
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	<1327639925-12920-22-git-send-email-ebiederm@xmission.com>
	<CAPLs8y8smiRj_Xbtme3v165CuyJOnJpA_pJNwdCMLWb2M1-e8A@mail.gmail.com>
Date: Mon, 30 Jan 2012 20:45:02 -0800
In-Reply-To: <CAPLs8y8smiRj_Xbtme3v165CuyJOnJpA_pJNwdCMLWb2M1-e8A@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Sun, 29 Jan 2012 21:31:41
	+0200")
Message-ID: <m162fsbhv5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+809SLtmXw3MznU/429nNlT+IUd6AGusY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

>
> Why do you only check the given @set after creating the new dir. Why
> not the parent dir too?

That is a race and a minor bug.  Somehow I had convinced myself that
either it didn't matter or that it would be hard to deal with, but
that doesn't hold up.  Oops.  Thankfully the final version using links
does not have this race/bug. 

Eric

