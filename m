Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2EZAc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:32:26 -0400
Received: from nm23-vm6.bullet.mail.ne1.yahoo.com ([98.138.91.116]:36100 "HELO
	nm23-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750972Ab2EZAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:32:25 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2012 20:32:25 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 980146.11331.bm@omp1024.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=cP+MuVjelRLuSL0I7diKXc94OTiNGTYxLbD3TCIlOYJQK65jR8xZ/NqnugAshztOid2jSF4jiyvRKWk7LxwcSrHRf7XRihFh76fVUjmE9yr5L//AdPXP9JOTPxw6KG5JONVnhhgRYTxW4BCc8v3X7EbIhTCOYlM+uy49Tn2U36A=;
X-YMail-OSG: vpxaLW0VM1nxMTdDN8NV8WqHOpNOBtbEgH__R8_0ft5Vrql
 _hdLG1.W09Gmq40_9wvPOAc97mE6_QZRHpvOuNB26rnDnewmhzdPZtFeOAvq
 9BQOUrleD4YjsiSGTDhWAvLuRU1ujHrLmsF9edxZFWWy7mfqi1DEyvtAptJQ
 4aBwp299FSRUY90RCk4dHzV.FSOtpR5yyoac3jHjf6XV8NuF.ZU.t1t7L4g3
 bcGIYkqzG4rbk2mLDp5xOFFIxYqZwdt0Hy5Eig09r547ZPRf4kfHO8g0f61t
 C_4OY_DQluMktBPj3cPS.morbScT6DgQOEMKFQWEalfU9hGlgM7K7tFUBvYu
 p5GFIB1nwOYu8N3h01UyIpZCSz5OKO2_jRe.GVDYtZyIDzNht4aNIAYhprjB
 D7xqQnc1lqFPh_ECB9R9ACJWihjK0Gqvf1m28ocAtEVEzLfsNgcnKOTvxKz3
 h00YUm4Lhx7R8baMVSw--
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.118.349524
Message-ID: <1337992009.23813.YahooMailClassic@web84502.mail.ne1.yahoo.com>
Date: Fri, 25 May 2012 17:26:49 -0700 (PDT)
From: kd6lvw@yahoo.com
Subject: Re: Regression Mounting /proc w/ kernel 3.4.0 - "uid" parameter no longer ignored.
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring "uid=#" is the documented behavior from the "mount(8)" man page for procfs.  That implies that the proposed patch should be [temporarily] installed.

I personally don't care if the option is restored or not.  My issue was that this side effect was not documented in any way in the change that occurred -- which affected documented behavior.

I mount my /proc file system in a "mount -at nonfs" statement in an initialization script.  The "uid" optional parameter was in /etc/fstab.  I have removed "uid" in my "at home" copy of the configuration but haven't visited the remote server to fix it there (I can't log in from remote as a result of this issue).

--- On Fri, 5/25/12, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> If it is *only* uid, maybe we should just expressly ignore it. Like
> the (completely untested) attached patch.


