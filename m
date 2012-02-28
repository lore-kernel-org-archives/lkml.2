Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2B1UBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:01:07 -0500
Received: from nm27.bullet.mail.sp2.yahoo.com ([98.139.91.97]:33870 "HELO
	nm27.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757290Ab2B1UBF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:01:05 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 909303.55675.bm@omp1068.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lHyrt5Z1Zo/upkPoggKHgjmR4PW9NZ4UGH0hj4WYUwyidE1vNVWQtNl9WwqwFWLx21pnT/+m6N+hor5YqvIENAfaAsZLgxcTvS+ssa1/23rAYZugQQ6Vy27nwvPDEhhl3EgJ7KJQXGkB0swOznhw1caZPedGyDNUbuP8LhFdAe0=;
X-YMail-OSG: SxnZRLoVM1kWIGEydD2sRZWMOXBW8ZoERGvH6fFbcAdE8z0
 OBkAthQarKoILcMO9XnH2vYbYMIiU4HAxRRqg__Zws2CpHT4HhVZBGfGl.C2
 jJjd6yQo6kPFTVFvTr0tB.KYldMzQcLtaskHi891.J0EDBlb.6fWJNPo.QnD
 ZSr91JCJrLcRU9DovRHL24_ZDToqYRbKnsRUsTo_s0dXF0uq68wKZQsF29uR
 yqEam6aEEw0cGSe62dzHG2m_D7ZpseCS9r4cc695r1Bg7gqhryWifQ31YzHF
 nLH35UnfgBM1Dsfj1S1rKSi2obKUyabLcBfMuqMRYytKlnnhR_BVQKY6QwDt
 6xwaFFVPwFclRgdQMIzgQJXC3UHA6d5WREIdRvrmiKdFh7QRx1RjMQU.4HA.
 _TDj7Sjz4FFeVfcfN7wfHbkiYaKixTbwsbKQ4Ma89F8JNa1YddcS8RZRqm.k
 9c0Oni64-
X-Mailer: YahooMailWebService/0.8.116.338427
Message-ID: <1330459264.72081.YahooMailNeo@web112013.mail.gq1.yahoo.com>
Date: Tue, 28 Feb 2012 12:01:04 -0800 (PST)
From: Ron Chen <ron_chen_123@yahoo.com>
Reply-To: Ron Chen <ron_chen_123@yahoo.com>
Subject: inotify & NFS error
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know that it is not possible (read: not technically feasible) for the inotify interface to support for NFS or other shared filesystems.

However, I think it is at least useful to tell the application developer that the file is on NFS and thus return of some sort (via errno), and thus when inotify_add_watch(2) is passed with a pathname on NFS, some sort of error will return.

I am one of the maintainers of Open Grid Scheduler (the official open-source Sun Grid Engine). I think having a reliable way of determining whether inotify gets events would greatly benefit applications that are commonly run in clustered environments (like Open Grid Scheduler, Grid Engine, and other HPC job schedulers). Most applications can switch back to polling when inotify is absent, but if the applications themselves do not know, then they can in the worst case sit there waiting forever.

 -Ron
