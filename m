Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0IOHnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 03:43:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33964 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0IOHnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 03:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LClCmtT+tPBLGcPiBQBo7l9pyFkoupRyD+aRmJIzNKo9uGvX3XYKxupZKY2E+/X98L
         K/9N+UXV0yb+lGHH9Bt7G+yZT1jMe4rZrW/1jua2o3eFElq1C7xpL/695j2PyESIqVRr
         aE7TRPs7ca5eArr/AJknMM2ZBpfWmK9q+1xf0=
Subject: Re: [PATCH 2/7] mtd: autoconvert trivial BKL users to private mutex
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <David.Woodhouse@intel.com>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1284494022-7346-3-git-send-email-arnd@arndb.de>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
	 <1284494022-7346-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 10:42:06 +0300
Message-ID: <1284536526.25181.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 21:53 +0200, Arnd Bergmann wrote:
> All these files use the big kernel lock in a trivial
> way to serialize their private file operations,
> typically resulting from an earlier semi-automatic
> pushdown from VFS.
> 
> None of these drivers appears to want to lock against
> other code, and they all use the BKL as the top-level
> lock in their file operations, meaning that there
> is no lock-order inversion problem.
> 
> Consequently, we can remove the BKL completely,
> replacing it with a per-file mutex in every case.
> Using a scripted approach means we can avoid
> typos.
> 

Looks good, are you going to merge them all yourself or you want this to
go via the mtd tree?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

