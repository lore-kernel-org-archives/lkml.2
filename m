Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1H3Apn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:45:43 -0400
Received: from nm16.bullet.mail.bf1.yahoo.com ([98.139.212.175]:26627 "HELO
	nm16.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750799Ab1H3Apm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:45:42 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 20:45:42 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 702469.90844.bm@omp1050.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:MIME-Version:Content-Type;
  b=YNWpyRB47wEEaCx/cIWlyw1FQ3iH3e/iZ/d1VcaqA/hKdaFVgs4JWh47t886dqQLFQTEHnGiYg9x+35qhdDzC3sf3zEgLzh63tbhapZLCohR//SjKyumVWOcmLBhNL9ai6OB715xEFuFhd7GpIH3p0wfJVh1NrODBaB6Po/y8tA=;
X-YMail-OSG: MUsIfS0VM1mmsH1ra4fCv9joFlUloZ._bOoyBzn1xGszhQt
 iVq_KqO3Wd1wwry__WGuJnAsDYjJtgmSS3gRBGWeRKDjBcFosrfu1vyHBHKm
 NG2qZQkNO9B433uobv9IRhFmrlwUf2kg5StpH2s0_4wwTOtuyCPy.NKzduQg
 T3KyMMuO4Nd98FeE865VgRRqxhUdevzTh4ken4DZNh8msJLtQ7B6cys6MkXZ
 rq_nI2HQyzimVLzG1U0nJfKOs.KIRsgNTAIPKE4svcyZbSpv8Xo3f0CB_8hO
 VDlXWv3GnYIBoediGV0oac7wxDFVciQmrQVVTiRy9QekmUcMElLL173lUzU4
 rXE01iqoPROladMPtoTRWn_p0.EE9IY7Ct3oWlISF9mrXTHaTKdkPJMKOVdo
 CqFNKTDajkekgP4GTmKd8_ClZcrIvFYjBAr0.OFSukJ4t36REOlXz
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1314664801.47724.YahooMailClassic@web161421.mail.bf1.yahoo.com>
Date: Mon, 29 Aug 2011 17:40:01 -0700 (PDT)
From: Darrell Anderson <humanreadable@yahoo.com>
Subject: rpc.rwalld is broken in 2.6.33.16
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I am using Slackware 13.1 and the 2.6.33.x kernel. Recently I compiled and installed the 2.6.33.18 kernel and noticed rpc.rwalld will not start or run. There are no error messages and the exit code when run directly from the command line is zero.

rpc.rwalld runs fine under 2.6.33.15.

Recompiling netkit-rwall against 2.6.33.18 made no difference.

I'll take a wild guess this is where the breakage occurred (2.6.33.16 change log):

commit 273f86df6960cfc9e6402f0eca7d5b77204c5dd8
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Fri Jun 17 10:14:59 2011 -0400
SUNRPC: Ensure the RPC client only quits on fatal signals
commit 5afa9133cfe67f1bfead6049a9640c9262a7101c upstream.
Fix a couple of instances where we were exiting the RPC client on
arbitrary signals. We should only do so on fatal signals.
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I compiled and installed the 2.6.33.16 kernel and confirmed rpc.rwalld fails to run there. So the change occurred from 2.6.33.15 to 2.6.33.16.

I am not a member of this list nor am I a kernel developer.

Please contact me at this email address if I can help further or provide additional information.

Thanks for all your great work and time.

Darrell Anderson
