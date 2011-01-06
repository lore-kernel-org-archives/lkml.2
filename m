Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1AFKoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:44:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1AFKoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:44:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SpRSjBog5HH4eUt3qOt2p3xG3JLavNzepexn6yxe4lHJqHTo405txCpOZI/VfObdl4
         0GIDOU/TX6xUyhjL7zP87GhXNwqFXms26ZPZ3DSNmk13CyMSwuvqQq0Rq+tg66GvJlfQ
         rglqwzA/btjSQvR/JTMK8JPnmrRDu+dZxl6uo=
MIME-Version: 1.0
In-Reply-To: <8679.1294247741@localhost>
References: <8679.1294247741@localhost>
Date: Thu, 6 Jan 2011 21:44:01 +1100
Message-ID: <AANLkTimtrinH-7tnGE2zxtoNNTEnqqD3ZDTTTWM-m0Uk@mail.gmail.com>
Subject: Re: 2.6.37-next - kernel BUG at fs/dcache.c:1363
From: Nick Piggin <npiggin@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Joel Becker <joel.becker@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 4:15 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> Saw this crash on a linux-next pulled yesterday at 2PM EST, kernel dies very
> early (looks like first time it touches configfs for anything - trying to boot
> with netconsole enabled caused it to die even faster).  I can bisect this if
> it doesn't immediately ring a bell...

Thanks, bah configfs isn't widely used.


> It dies here:
>
> void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
> {
>        BUG_ON(dentry->d_op);
>
> Am guessing configfs passed in a dentry that wasn't filled in enough.
>
> (hand-transcribed from a crappy cellphone pic)
>
> kernel BUG at fs/dcache.c:1363

Thanks. It actually passed in a dentry that appears to have already been
used for something. This is not exactly a nice thing for a filesystem to do
and probably indicates an underlying bug anyway (or at least something
the vfs doesn't guarantee the safety of).

Taking a look now.

Thanks,
Nick
