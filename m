Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1FTN6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:58:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43532 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1FTN6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WU97lTr9DYEYhEGJdN9RG2scDzeEwIUzD1u756a4nVl9pWuGHLwB5k3q2UweU+hrra
         Y5ra2j7RKDwZhzbTo8M/44gpcfIxNzcqwDH6PNYAxt+rfv0f/e4i9uI1obJ7AQFcrnQf
         AS7CYgG7VV3Pjto0Wb93hDyRwpp9zYKW8J3Ho=
MIME-Version: 1.0
In-Reply-To: <20110620103917.GA5230@albatros>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
	<alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
	<20110620103917.GA5230@albatros>
Date: Mon, 20 Jun 2011 16:58:10 +0300
Message-ID: <BANLkTimb==tuDKQ2jyYS+Py0FfNxKVc+Pg@mail.gmail.com>
Subject: Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gid= is bad choice because
a) e. g. VFAT uses uid=/gid= mount options to make all inodes to have
certain uid/gid
b) uid=/gid=, IIRC, will be added as generic VFS mount options (like ro)
   with semantics described in a)

so having different semantics for /proc won't be good.
