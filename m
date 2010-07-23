Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0GWRdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:33:24 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:33266 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755508Ab0GWRdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:33:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lhDTtrT+Uz8Bz6gcJ1v4kha4osl8WRtm0VKXN9FoNqWn6xN5WZRAZZKwcXJqLzzRJMHh7dktXb46Gm+sQd9mULKBRV8AR81Gur3apwrPvMmpd6WkueUQ7sMGX0EIg0nX;
Date: Fri, 23 Jul 2010 10:33:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Tino Keitel" <tino.keitel+xorg@tikei.de>
Subject: Re: [Bug #16207] Suspend and VT switch hangs since 2.6.34
Message-ID: <20100723103336.539a3d61@virtuousgeek.org>
In-Reply-To: <PRbv8sgxY6G.A.j1F.aVYSMB@chimera>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	<PRbv8sgxY6G.A.j1F.aVYSMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 14:15:52 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16207
> Subject		: Suspend and VT switch hangs since 2.6.34
> Submitter	: Tino Keitel <tino.keitel+xorg@tikei.de>
> Date		: 2010-06-09 17:53 (45 days old)
> Message-ID	: <20100609175356.GA17332@x61.home>
> References	: http://marc.info/?l=linux-kernel&m=127610606214060&w=2

I think this may actually be an X server bug.  2.6.34 introduced some
new features that X drivers take advantage of, but there was some
bugginess in the X server's handling of client block and unblock,
leading to hangs at VT switch time.

This could be related to some upstream bugs in the X server
(bugs.freedesktop.org):
28998
28365
27035

Can you check those out and see if they're relevant?  27035 and 28998 in
particular fixed VT switch problems for me.

-- 
Jesse Barnes, Intel Open Source Technology Center
