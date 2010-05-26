Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522Ab0EZWeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:34:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33344 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab0EZWep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=CSs5YZoQNGGCpYbkbs6ZlAEuabrZ9bkbhWX06Tanhc+aKTRmhPOfxhAnGDXHZ3APQe
         V1dwS6JXyQMLfziQgXh7hUMrAgs7IUTCVlNlxV+sRLHuXnjq2tzoWCgGMRzCh8TQdzjX
         njdRTDHukFLM9Q0VK83M+JxtTJ0WSjG6aQnKE=
Date: Thu, 27 May 2010 00:34:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: smatch 1.55 released
Message-ID: <20100526223417.GP22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a static checker for C.  The core parts basically do flow
analysis and then there are project specific checks as well.  The
website is:  http://smatch.sf.net

To use it do:
	git clone git://repo.or.cz/smatch.git
	cd smatch ; make ; cd /usr/src/kernel
	make CHECK="~/path/to/smatch/smatch -p=kernel" C=1 \
                   bzImage modules | tee warns.txt

Things that have changed since 1.54:
* The array overflow check is now useful.
* There is a new check for precedence bugs caused by macro expansion.
* The checks for null pointer dereferences were rewritten and now have
    fewer false positives.
* Some kernel specific tests were added for kunmap(),
    release_resource(), resource_size(), and mod_timer().

Major Bugs:
* Smatch doesn't handle loops correctly.
* It doesn't do cross function analysis.
* It doesn't understand code like this:
	foo->bar = NULL;
	foo = not_null();
	foo->bar->baz;  // <- Smatch complains about a null dereference.
* Too many false positives generally.

Anyway, please test it out.  :)

regards,
dan carpenter
