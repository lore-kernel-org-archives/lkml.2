Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1LMLs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:48:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1LMLsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:48:25 -0500
Message-ID: <4EE73B88.3040101@canonical.com>
Date: Tue, 13 Dec 2011 11:48:24 +0000
From: James Hunt <james.hunt@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Upstart Devel List <upstart-devel@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Upstart 1.4 "Let them speak" released
References: <4EE738CA.8030409@canonical.com> <20111213113846.GE26355@tango.0pointer.de>
In-Reply-To: <20111213113846.GE26355@tango.0pointer.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Lennart,

On 13/12/11 11:38, Lennart Poettering wrote:
> On Tue, 13.12.11 11:36, James Hunt (james.hunt@canonical.com) wrote: Just out of curiosity: how
> is rotation handled for this? If you pass the file fd directly to the spawned service you can't
> really rotate the file ever, since you cannot ask the service to reopen the file. So what do 
> you do?
The trick is we don't pass the logfile fd to the job (the jobs stdout+stderr are connected to one
end of a pty). Regarding rotation, Upstart detects if the logfile that it manages was deleted. If
so, it simply closes and reopens the corresponding file. This allows tools like logrotate to
handle rotation.

Kind regards,

James.
- --
James Hunt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO5zuHAAoJEJ1Q4UTmNXMnZe8P/2dgwOcThbDmCl4sunR7SDmM
4TQ+lEW1bQs/GthaZ9q8J+xFszzlEuzwjbnNHKyNIlivhn3pHcJ1OldpcvzxFAIf
2zEVrJ5mlixUaHA8OTm2UB0wz3Uk5yecW73LKWOXOgk4qi8L7icQAkh+4hsmIuj+
Atdk29krHvmXiD37HGbtU/IcMuNmnmtpBy8V4NPbDYCWTK0DZGFcx9qT3PGDmAq6
kzh8XdC35OeLA41X4cUYAKpiE6QEGdusAqw1vjI/Sne36JJZoMzTTmMz3zwAaEQW
ennSaa8jgVhUaMfhagTVE6MFnDha+hA5wHvZ+KT7G/brqTAUCW7eHpyZM+lf0Had
fEO0Bmaukrz+usEr3m5zNTMHPctN0Uy4xPOs3uhGPEjdg+tCnCPjiwEhHb++75LZ
OBPp9axf8FUZDQpT4w6cu+1m36L9WTcLaBJx9MRTNZP+pD3TjquEhA/ppqObNRn3
K/05+wVJwRVL3ZG2I3/A9lP5/kjWfdZ48T2W4yYN0HyqETvlz5gw7SXioRUoETAf
uXXkVYLkbVjSLdmpb/qYS6N8bCgqVIL/amW0gt233xpfYmsbBtJvjLU2cpfbOtZ2
0E6Mjq94il6DqP6H+HZQWYM43yd/KUr2vAlUUdDDtNOmkFaJ5fFEOKT8Ng8rpjWF
oOzHL2pM/I/IFT9Dvmlp
=NB4b
-----END PGP SIGNATURE-----
