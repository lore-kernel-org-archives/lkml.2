Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab1LGUeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:34:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51416 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab1LGUep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:34:45 -0500
Message-ID: <4EDFCDD4.2080603@zytor.com>
Date: Wed, 07 Dec 2011 12:34:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Colin Walters <walters@verbum.org>
CC: LKML <linux-kernel@vger.kernel.org>, morgan@kernel.org, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Subject: Re: chroot(2) and bind mounts as non-root
References: <1323280461.10724.13.camel@lenny>
In-Reply-To: <1323280461.10724.13.camel@lenny>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 09:54 AM, Colin Walters wrote:
> 
> The historical reason one can't call chroot(2) as non-root is because of
> setuid binaries (hard link a setuid binary into chroot of your choice
> with trojaned libc.so).

No.  The historical reason is that it lets anyone escape a chroot jail:

	mkdir("jailbreak", 0666);
	chroot("jailbreak");

	/* Now the cwd is outside the root, and therefore not bound by
           it, walk the chain of .. directories until they don't change
           anymore */

	chroot(".");	/* Change the root to the system root */

Oops.

	-hpa


	
