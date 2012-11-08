Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2KHOwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:52:55 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:36181 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2KHOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:52:51 -0500
Date: Thu, 8 Nov 2012 09:52:43 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Message-ID: <999858348.7901147.1352386363812.JavaMail.root@redhat.com>
In-Reply-To: <20121108141925.GA20083@aepfle.de>
Subject: Re: [PATCH] Tools: hv: Fix for long file names from readdir
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.4.165]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -        char dev_id[256];
> > +        char dev_id[512];
> 
> Shouldnt that be PATH_MAX or similar?

dirent->d_name should be PATH_MAX, but it is mostly 
not guaranteed. And then the dev_id is concatenated
with two strings so it can exceed 256 bytes.

After discussion with K. Y. Srinivasan I just doubled
the size and added size checks for sanity.

Tomas
