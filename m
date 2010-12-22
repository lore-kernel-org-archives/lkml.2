Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0LVSEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:04:36 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:35791 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0LVSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hMHGRrxzlPWU4ccXAKpVSrwjwjzaMUj2FI7ajYFWK8/pdkvWH1z3ffpfVj5SpqSzwe
         ta68XRJA9SScPW5UbmcMS/Uo/iE8IUMIeBp9p2RFLuJQeNzSud723vfCwRfZ1+APL3hf
         E4I+gEl7/1jgzQvk7RiJQeNtDfa1Xw8NpgDeM=
Date: Wed, 22 Dec 2010 19:04:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reiserfs deadlock in  2.6.36
Message-ID: <20101222180428.GD1739@nowhere>
References: <201011181650.00152.roucaries.bastien@gmail.com>
 <20101202174328.GA1750@nowhere>
 <201012161449.52318.roucaries.bastien@gmail.com>
 <201012221850.51242.roucaries.bastien@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201012221850.51242.roucaries.bastien@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 06:50:48PM +0100, Bastien ROUCARIES wrote:
> Le jeudi 16 décembre 2010 14:49:48, Bastien ROUCARIES a écrit :
> > Le jeudi 2 décembre 2010 18:43:32, vous avez écrit :
> > > On Fri, Nov 26, 2010 at 05:57:05PM +0100, Bastien ROUCARIES wrote:
> > > > Dear frederic,
> I achieve to reproduce it. BTW it is my home partition with acl enable

How do you know you reproduced it? You had a crash before using SysRq?
Or you felt a deadlock or so?

What's interesting is that report is that there is no blocked task
that holds the reiserfs lock.

So I really feel the problem is that someone opened the journal but did not
release it.

How hard is it to reproduce now? If it's not so hard or haphazard, we should
start a bisection. Otherwise I think we'll need to do some tracing and this
is going to take several tries :)
