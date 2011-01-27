Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1A0W7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:59:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab1A0W7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <20110127134710.GB519@camk.edu.pl>
References: <20110127134710.GB519@camk.edu.pl>
Date: Fri, 28 Jan 2011 08:59:21 +1000
Message-ID: <AANLkTimOM7KDtFkU=CmXZ8J2FqekY=EjCuOdtZHQJQWT@mail.gmail.com>
Subject: Re: [PATCH] Fix prlimit64 for suid/sgid processes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kacper Kornet <kornet@camk.edu.pl>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/11, Kacper Kornet <kornet@camk.edu.pl> wrote:
> Since check_prlimit_permission always fails in the case of SUID/GUID
> processes, such processes are not able to read or set their own limits.
> This commit changes this by assuming that process can always read/change
> its own limits.

Shouldn't this be fixed in check_prlimit_permissions() instead of in the caller?

     Linus
