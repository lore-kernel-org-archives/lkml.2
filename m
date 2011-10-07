Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab1JGKPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:15:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33129 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759751Ab1JGKPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:15:11 -0400
Date: Fri, 7 Oct 2011 11:12:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Subject: Re: A =?UTF-8?B?UGx1bWJlcuKAmXM=?= Wish List for Linux
Message-ID: <20111007111231.6e11d18e@lxorguk.ukuu.org.uk>
In-Reply-To: <1317943022.1095.25.camel@mop>
References: <1317943022.1095.25.camel@mop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * (ioctl based?) interface to query and modify the label of a mounted
> FAT volume:

Seems sensible - or it could go in sysfs ?

> A FAT labels is implemented as a hidden directory entry in the file
> system which need to be renamed when changing the file system label,

That would be ugly - it works for FAT as you can create an imaginary name
which is not possible on the fs, but that isn't true for say ext4. Sysfs
sounds the logic way, it means adding chunks of code to various file
systems.

> * expose CAP_LAST_CAP somehow in the running kernel at runtime:
> Userspace needs to know the highest valid capability of the running
> kernel, which right now cannot reliably be retrieved from header files
> only. The fact that this value cannot be detected properly right now
> creates various problems for libraries compiled on newer header files
> which are run on older kernels. They assume capabilities are available
> which actually aren’t. Specifically, libcap-ng claims that all running
> processes retain the higher capabilities in this case due to the
> “inverted” semantics of CapBnd in /proc/$PID/status.

You can probably deduce this by poking around but to me it seems like a
very sensible idea.

> * allow changing argv[] of a process without mucking with environ[]:
> Something like setproctitle() or a prctl() would be ideal. Of course it
> is questionable if services like sendmail make use of this, but otoh for
> services which fork but do not immediately exec() another binary being
> able to rename this child processes in ps is of importance.

Yes, its a real valuable tool for r00tkits, worms and general purpose
deception.

