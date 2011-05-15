Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1EOSLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 14:11:11 -0400
Received: from nm5-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.165]:38566 "HELO
	nm5-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751249Ab1EOSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 14:11:09 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 14:11:09 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 517960.51286.bm@omp1052.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=fzhNAcll2Wph79hbFqrmCJ91RprcRlclfxWGOIb8vwzZDO34UIOcPuH3kF6BWVzY/2ySMH/0vOAH4fc+EpF5/ORaKS7KfWDVuOomTEMopmx1xME8z/fwYSNoojv4daybcfQYHd78QCB80rc1MX5XrL5mL0wviLjVHd67yg2jO5o=;
Message-ID: <177649.65029.qm@web130106.mail.mud.yahoo.com>
X-YMail-OSG: d8ksBbEVM1lJsRrp66jLOZHY6HsSdz2r.Sx8fDfowOo9qYu
 GdSYlllzGYfl3S5fAMp4GnhLeA59fjvKPNZLHNEy2Xbs8LLH1IK51FcqXoRt
 VfjC5ML_r7xomBZx7qb9ATxSEn.uQbxzsJTaqZ5qb.z_fC6ADVACGiLiWYlT
 0.Hp3KjjBONol0GN7hEoSaL13m19N1cf9tH1dvBhQb9wC6dkSOuUko6Nbziu
 oesiJOdWanxd8hT0HaikmmPqK15vZc5z5iGrTu6zDR3bBBwJoYKH4x67D.Jo
 8MEjmBv6YYwuL_t2TAz3y9_ijecKtuePHzP_K.vBhi5M2A1X6UkX2jb54Vwd
 oX35wH1CqzLLk1pAYsExv3knAgsLRqVU23XeNknBNVk9vqthEQwscqWtexoo
 bGh.KHO0FjC13
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.111.303096
Date: Sun, 15 May 2011 11:04:27 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Possible coding issue in udf??
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <m2pqnjevjc.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get it now.

Thanks.

I code, therefore I am


--- On Sun, 5/15/11, Andreas Schwab <schwab@linux-m68k.org> wrote:

> From: Andreas Schwab <schwab@linux-m68k.org>
> Subject: Re: Possible coding issue in udf??
> To: "Alex Davis" <alex14641@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
> Date: Sunday, May 15, 2011, 1:13 PM
> Alex Davis <alex14641@yahoo.com>
> writes:
> 
> > In fs/udf/inode.c, line 1455, linux 2.6.35, there is
> the following code:
> >
> >     udfperms = ((inode->i_mode &
> S_IRWXO)) |
> >        
>    ((inode->i_mode & S_IRWXG) <<
> 2) |
> >        
>    ((inode->i_mode & S_IRWXU) <<
> 4);
> >
> > Shouldn't we be shifting by 3 bits? i.e:
> >     udfperms = ((inode->i_mode &
> S_IRWXO)) |
> >        
>    ((inode->i_mode & S_IRWXG) <<
> 3) |
> >        
>    ((inode->i_mode & S_IRWXU) <<
> 6);
> 
> udfperms contains three bit fields of 5 bits each, of which
> 3 bits are
> each filled from one of the three RWX parts of i_mode, and
> 2 bits
> (DELETE and CHATTR) are added later.  Thus each of the
> three bit fields
> are expanded from 3 to 5 bits, so that the second one needs
> to be
> shifted by 2 and the third one by 4.
> 
> Andreas.
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3
> 44D5 214B 8276 4ED5
> "And now for something completely different."
> 
