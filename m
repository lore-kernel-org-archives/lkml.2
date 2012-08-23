Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab2HWOgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:36:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36489 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab2HWOgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:36:18 -0400
Date: Thu, 23 Aug 2012 16:36:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120823143614.GA11936@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>,
	linux-kernel@vger.kernel.org
References: <20120822133136.GC6899@x1.osrc.amd.com>
 <20120822191516.8483.64529.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120822191516.8483.64529.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:20:03PM +0300, Jussi Kivilinna wrote:
> Actually it does look better, at least for encryption. Decryption had different
> ordering for test, which appears to be bad on bulldozer as it is on
> sandy-bridge.
> 
> So, yet another patch then :)

Here you go:

[  153.736745] 
[  153.736745] testing speed of async ecb(twofish) encryption
[  153.745806] test 0 (128 bit key, 16 byte blocks): 4832343 operations in 1 seconds (77317488 bytes)
[  154.752525] test 1 (128 bit key, 64 byte blocks): 2049979 operations in 1 seconds (131198656 bytes)
[  155.755195] test 2 (128 bit key, 256 byte blocks): 620439 operations in 1 seconds (158832384 bytes)
[  156.761694] test 3 (128 bit key, 1024 byte blocks): 173900 operations in 1 seconds (178073600 bytes)
[  157.768282] test 4 (128 bit key, 8192 byte blocks): 22366 operations in 1 seconds (183222272 bytes)
[  158.774815] test 5 (192 bit key, 16 byte blocks): 4850741 operations in 1 seconds (77611856 bytes)
[  159.781498] test 6 (192 bit key, 64 byte blocks): 2046772 operations in 1 seconds (130993408 bytes)
[  160.788163] test 7 (192 bit key, 256 byte blocks): 619915 operations in 1 seconds (158698240 bytes)
[  161.794636] test 8 (192 bit key, 1024 byte blocks): 173442 operations in 1 seconds (177604608 bytes)
[  162.801242] test 9 (192 bit key, 8192 byte blocks): 22083 operations in 1 seconds (180903936 bytes)
[  163.807793] test 10 (256 bit key, 16 byte blocks): 4862951 operations in 1 seconds (77807216 bytes)
[  164.814449] test 11 (256 bit key, 64 byte blocks): 2050036 operations in 1 seconds (131202304 bytes)
[  165.821121] test 12 (256 bit key, 256 byte blocks): 620349 operations in 1 seconds (158809344 bytes)
[  166.827621] test 13 (256 bit key, 1024 byte blocks): 173917 operations in 1 seconds (178091008 bytes)
[  167.834218] test 14 (256 bit key, 8192 byte blocks): 22362 operations in 1 seconds (183189504 bytes)
[  168.840798] 
[  168.840798] testing speed of async ecb(twofish) decryption
[  168.849968] test 0 (128 bit key, 16 byte blocks): 4889899 operations in 1 seconds (78238384 bytes)
[  169.855439] test 1 (128 bit key, 64 byte blocks): 2052293 operations in 1 seconds (131346752 bytes)
[  170.862113] test 2 (128 bit key, 256 byte blocks): 616979 operations in 1 seconds (157946624 bytes)
[  171.868631] test 3 (128 bit key, 1024 byte blocks): 172773 operations in 1 seconds (176919552 bytes)
[  172.875244] test 4 (128 bit key, 8192 byte blocks): 22224 operations in 1 seconds (182059008 bytes)
[  173.881777] test 5 (192 bit key, 16 byte blocks): 4893653 operations in 1 seconds (78298448 bytes)
[  174.888451] test 6 (192 bit key, 64 byte blocks): 2048078 operations in 1 seconds (131076992 bytes)
[  175.895131] test 7 (192 bit key, 256 byte blocks): 619204 operations in 1 seconds (158516224 bytes)
[  176.901651] test 8 (192 bit key, 1024 byte blocks): 172569 operations in 1 seconds (176710656 bytes)
[  177.908253] test 9 (192 bit key, 8192 byte blocks): 21888 operations in 1 seconds (179306496 bytes)
[  178.914781] test 10 (256 bit key, 16 byte blocks): 4921751 operations in 1 seconds (78748016 bytes)
[  179.917481] test 11 (256 bit key, 64 byte blocks): 2051219 operations in 1 seconds (131278016 bytes)
[  180.920147] test 12 (256 bit key, 256 byte blocks): 618536 operations in 1 seconds (158345216 bytes)
[  181.926637] test 13 (256 bit key, 1024 byte blocks): 172886 operations in 1 seconds (177035264 bytes)
[  182.933249] test 14 (256 bit key, 8192 byte blocks): 22222 operations in 1 seconds (182042624 bytes)
[  183.939803] 
[  183.939803] testing speed of async cbc(twofish) encryption
[  183.953902] test 0 (128 bit key, 16 byte blocks): 5195403 operations in 1 seconds (83126448 bytes)
[  184.962487] test 1 (128 bit key, 64 byte blocks): 1912010 operations in 1 seconds (122368640 bytes)
[  185.969150] test 2 (128 bit key, 256 byte blocks): 540125 operations in 1 seconds (138272000 bytes)
[  186.975650] test 3 (128 bit key, 1024 byte blocks): 140631 operations in 1 seconds (144006144 bytes)
[  187.982411] test 4 (128 bit key, 8192 byte blocks): 17737 operations in 1 seconds (145301504 bytes)
[  188.988782] test 5 (192 bit key, 16 byte blocks): 5182287 operations in 1 seconds (82916592 bytes)
[  189.995435] test 6 (192 bit key, 64 byte blocks): 1912356 operations in 1 seconds (122390784 bytes)
[  191.002093] test 7 (192 bit key, 256 byte blocks): 540991 operations in 1 seconds (138493696 bytes)
[  192.008600] test 8 (192 bit key, 1024 byte blocks): 140791 operations in 1 seconds (144169984 bytes)
[  193.015197] test 9 (192 bit key, 8192 byte blocks): 17609 operations in 1 seconds (144252928 bytes)
[  194.021740] test 10 (256 bit key, 16 byte blocks): 5191521 operations in 1 seconds (83064336 bytes)
[  195.028534] test 11 (256 bit key, 64 byte blocks): 1906226 operations in 1 seconds (121998464 bytes)
[  196.035069] test 12 (256 bit key, 256 byte blocks): 540479 operations in 1 seconds (138362624 bytes)
[  197.041579] test 13 (256 bit key, 1024 byte blocks): 140654 operations in 1 seconds (144029696 bytes)
[  198.048164] test 14 (256 bit key, 8192 byte blocks): 17741 operations in 1 seconds (145334272 bytes)
[  199.054717] 
[  199.054717] testing speed of async cbc(twofish) decryption
[  199.064019] test 0 (128 bit key, 16 byte blocks): 4783914 operations in 1 seconds (76542624 bytes)
[  200.069414] test 1 (128 bit key, 64 byte blocks): 1954641 operations in 1 seconds (125097024 bytes)
[  201.076079] test 2 (128 bit key, 256 byte blocks): 604230 operations in 1 seconds (154682880 bytes)
[  202.082586] test 3 (128 bit key, 1024 byte blocks): 167613 operations in 1 seconds (171635712 bytes)
[  203.089199] test 4 (128 bit key, 8192 byte blocks): 21451 operations in 1 seconds (175726592 bytes)
[  204.095716] test 5 (192 bit key, 16 byte blocks): 4795759 operations in 1 seconds (76732144 bytes)
[  205.102390] test 6 (192 bit key, 64 byte blocks): 1953134 operations in 1 seconds (125000576 bytes)
[  206.109055] test 7 (192 bit key, 256 byte blocks): 599761 operations in 1 seconds (153538816 bytes)
[  207.115564] test 8 (192 bit key, 1024 byte blocks): 166437 operations in 1 seconds (170431488 bytes)
[  208.122184] test 9 (192 bit key, 8192 byte blocks): 20789 operations in 1 seconds (170303488 bytes)
[  209.128728] test 10 (256 bit key, 16 byte blocks): 4794873 operations in 1 seconds (76717968 bytes)
[  210.135375] test 11 (256 bit key, 64 byte blocks): 1953978 operations in 1 seconds (125054592 bytes)
[  211.142039] test 12 (256 bit key, 256 byte blocks): 604269 operations in 1 seconds (154692864 bytes)
[  212.148556] test 13 (256 bit key, 1024 byte blocks): 167571 operations in 1 seconds (171592704 bytes)
[  213.155143] test 14 (256 bit key, 8192 byte blocks): 21453 operations in 1 seconds (175742976 bytes)
[  214.161698] 
[  214.161698] testing speed of async ctr(twofish) encryption
[  214.175571] test 0 (128 bit key, 16 byte blocks): 4581950 operations in 1 seconds (73311200 bytes)
[  215.184354] test 1 (128 bit key, 64 byte blocks): 1944709 operations in 1 seconds (124461376 bytes)
[  216.191166] test 2 (128 bit key, 256 byte blocks): 594086 operations in 1 seconds (152086016 bytes)
[  217.197536] test 3 (128 bit key, 1024 byte blocks): 163216 operations in 1 seconds (167133184 bytes)
[  218.204149] test 4 (128 bit key, 8192 byte blocks): 21075 operations in 1 seconds (172646400 bytes)
[  219.210813] test 5 (192 bit key, 16 byte blocks): 4705554 operations in 1 seconds (75288864 bytes)
[  220.217330] test 6 (192 bit key, 64 byte blocks): 1963988 operations in 1 seconds (125695232 bytes)
[  221.224004] test 7 (192 bit key, 256 byte blocks): 581953 operations in 1 seconds (148979968 bytes)
[  222.230513] test 8 (192 bit key, 1024 byte blocks): 162790 operations in 1 seconds (166696960 bytes)
[  223.237126] test 9 (192 bit key, 8192 byte blocks): 20706 operations in 1 seconds (169623552 bytes)
[  224.243642] test 10 (256 bit key, 16 byte blocks): 4437112 operations in 1 seconds (70993792 bytes)
[  225.250324] test 11 (256 bit key, 64 byte blocks): 1963735 operations in 1 seconds (125679040 bytes)
[  226.256990] test 12 (256 bit key, 256 byte blocks): 596765 operations in 1 seconds (152771840 bytes)
[  227.263498] test 13 (256 bit key, 1024 byte blocks): 163385 operations in 1 seconds (167306240 bytes)
[  228.270232] test 14 (256 bit key, 8192 byte blocks): 20950 operations in 1 seconds (171622400 bytes)
[  229.276657] 
[  229.276657] testing speed of async ctr(twofish) decryption
[  229.285975] test 0 (128 bit key, 16 byte blocks): 4571340 operations in 1 seconds (73141440 bytes)
[  230.291288] test 1 (128 bit key, 64 byte blocks): 1949949 operations in 1 seconds (124796736 bytes)
[  231.297951] test 2 (128 bit key, 256 byte blocks): 591529 operations in 1 seconds (151431424 bytes)
[  232.304470] test 3 (128 bit key, 1024 byte blocks): 163609 operations in 1 seconds (167535616 bytes)
[  233.311073] test 4 (128 bit key, 8192 byte blocks): 20975 operations in 1 seconds (171827200 bytes)
[  234.317581] test 5 (192 bit key, 16 byte blocks): 4639461 operations in 1 seconds (74231376 bytes)
[  235.324307] test 6 (192 bit key, 64 byte blocks): 1963173 operations in 1 seconds (125643072 bytes)
[  236.330929] test 7 (192 bit key, 256 byte blocks): 585030 operations in 1 seconds (149767680 bytes)
[  237.337445] test 8 (192 bit key, 1024 byte blocks): 162872 operations in 1 seconds (166780928 bytes)
[  238.344050] test 9 (192 bit key, 8192 byte blocks): 20728 operations in 1 seconds (169803776 bytes)
[  239.350603] test 10 (256 bit key, 16 byte blocks): 4443427 operations in 1 seconds (71094832 bytes)
[  240.357259] test 11 (256 bit key, 64 byte blocks): 1965011 operations in 1 seconds (125760704 bytes)
[  241.363914] test 12 (256 bit key, 256 byte blocks): 590193 operations in 1 seconds (151089408 bytes)
[  242.370422] test 13 (256 bit key, 1024 byte blocks): 163370 operations in 1 seconds (167290880 bytes)
[  243.377018] test 14 (256 bit key, 8192 byte blocks): 20969 operations in 1 seconds (171778048 bytes)
[  244.383546] 
[  244.383546] testing speed of async lrw(twofish) encryption
[  244.398118] test 0 (256 bit key, 16 byte blocks): 3582956 operations in 1 seconds (57327296 bytes)
[  245.406230] test 1 (256 bit key, 64 byte blocks): 1618011 operations in 1 seconds (103552704 bytes)
[  246.412911] test 2 (256 bit key, 256 byte blocks): 502411 operations in 1 seconds (128617216 bytes)
[  247.419427] test 3 (256 bit key, 1024 byte blocks): 140501 operations in 1 seconds (143873024 bytes)
[  248.422071] test 4 (256 bit key, 8192 byte blocks): 18166 operations in 1 seconds (148815872 bytes)
[  249.424613] test 5 (320 bit key, 16 byte blocks): 3576354 operations in 1 seconds (57221664 bytes)
[  250.431245] test 6 (320 bit key, 64 byte blocks): 1626817 operations in 1 seconds (104116288 bytes)
[  251.437908] test 7 (320 bit key, 256 byte blocks): 504222 operations in 1 seconds (129080832 bytes)
[  252.444407] test 8 (320 bit key, 1024 byte blocks): 140962 operations in 1 seconds (144345088 bytes)
[  253.451020] test 9 (320 bit key, 8192 byte blocks): 17955 operations in 1 seconds (147087360 bytes)
[  254.457555] test 10 (384 bit key, 16 byte blocks): 3558173 operations in 1 seconds (56930768 bytes)
[  255.464210] test 11 (384 bit key, 64 byte blocks): 1630951 operations in 1 seconds (104380864 bytes)
[  256.470866] test 12 (384 bit key, 256 byte blocks): 504089 operations in 1 seconds (129046784 bytes)
[  257.477383] test 13 (384 bit key, 1024 byte blocks): 141065 operations in 1 seconds (144450560 bytes)
[  258.483979] test 14 (384 bit key, 8192 byte blocks): 18168 operations in 1 seconds (148832256 bytes)
[  259.490542] 
[  259.490542] testing speed of async lrw(twofish) decryption
[  259.499858] test 0 (256 bit key, 16 byte blocks): 3557489 operations in 1 seconds (56919824 bytes)
[  260.505175] test 1 (256 bit key, 64 byte blocks): 1630277 operations in 1 seconds (104337728 bytes)
[  261.511865] test 2 (256 bit key, 256 byte blocks): 503750 operations in 1 seconds (128960000 bytes)
[  262.518383] test 3 (256 bit key, 1024 byte blocks): 140698 operations in 1 seconds (144074752 bytes)
[  263.524988] test 4 (256 bit key, 8192 byte blocks): 18124 operations in 1 seconds (148471808 bytes)
[  264.531487] test 5 (320 bit key, 16 byte blocks): 3579978 operations in 1 seconds (57279648 bytes)
[  265.538179] test 6 (320 bit key, 64 byte blocks): 1632251 operations in 1 seconds (104464064 bytes)
[  266.544843] test 7 (320 bit key, 256 byte blocks): 502180 operations in 1 seconds (128558080 bytes)
[  267.551350] test 8 (320 bit key, 1024 byte blocks): 139727 operations in 1 seconds (143080448 bytes)
[  268.557964] test 9 (320 bit key, 8192 byte blocks): 17731 operations in 1 seconds (145252352 bytes)
[  269.564481] test 10 (384 bit key, 16 byte blocks): 3570236 operations in 1 seconds (57123776 bytes)
[  270.571162] test 11 (384 bit key, 64 byte blocks): 1623126 operations in 1 seconds (103880064 bytes)
[  271.577828] test 12 (384 bit key, 256 byte blocks): 504857 operations in 1 seconds (129243392 bytes)
[  272.584346] test 13 (384 bit key, 1024 byte blocks): 140801 operations in 1 seconds (144180224 bytes)
[  273.586961] test 14 (384 bit key, 8192 byte blocks): 18139 operations in 1 seconds (148594688 bytes)
[  274.589525] 
[  274.589525] testing speed of async xts(twofish) encryption
[  274.603741] test 0 (256 bit key, 16 byte blocks): 3098851 operations in 1 seconds (49581616 bytes)
[  275.612164] test 1 (256 bit key, 64 byte blocks): 1577161 operations in 1 seconds (100938304 bytes)
[  276.618836] test 2 (256 bit key, 256 byte blocks): 525612 operations in 1 seconds (134556672 bytes)
[  277.625459] test 3 (256 bit key, 1024 byte blocks): 150507 operations in 1 seconds (154119168 bytes)
[  278.632105] test 4 (256 bit key, 8192 byte blocks): 19633 operations in 1 seconds (160833536 bytes)
[  279.638587] test 5 (384 bit key, 16 byte blocks): 3092237 operations in 1 seconds (49475792 bytes)
[  280.645261] test 6 (384 bit key, 64 byte blocks): 1576545 operations in 1 seconds (100898880 bytes)
[  281.651795] test 7 (384 bit key, 256 byte blocks): 526516 operations in 1 seconds (134788096 bytes)
[  282.658305] test 8 (384 bit key, 1024 byte blocks): 150782 operations in 1 seconds (154400768 bytes)
[  283.664935] test 9 (384 bit key, 8192 byte blocks): 19632 operations in 1 seconds (160825344 bytes)
[  284.671425] test 10 (512 bit key, 16 byte blocks): 3164770 operations in 1 seconds (50636320 bytes)
[  285.678254] test 11 (512 bit key, 64 byte blocks): 1586822 operations in 1 seconds (101556608 bytes)
[  286.684781] test 12 (512 bit key, 256 byte blocks): 527705 operations in 1 seconds (135092480 bytes)
[  287.691290] test 13 (512 bit key, 1024 byte blocks): 150918 operations in 1 seconds (154540032 bytes)
[  288.697885] test 14 (512 bit key, 8192 byte blocks): 19640 operations in 1 seconds (160890880 bytes)
[  289.704422] 
[  289.704422] testing speed of async xts(twofish) decryption
[  289.713733] test 0 (256 bit key, 16 byte blocks): 3082480 operations in 1 seconds (49319680 bytes)
[  290.719098] test 1 (256 bit key, 64 byte blocks): 1571464 operations in 1 seconds (100573696 bytes)
[  291.725752] test 2 (256 bit key, 256 byte blocks): 528360 operations in 1 seconds (135260160 bytes)
[  292.732271] test 3 (256 bit key, 1024 byte blocks): 150115 operations in 1 seconds (153717760 bytes)
[  293.738874] test 4 (256 bit key, 8192 byte blocks): 19513 operations in 1 seconds (159850496 bytes)
[  294.745427] test 5 (384 bit key, 16 byte blocks): 3087055 operations in 1 seconds (49392880 bytes)
[  295.752083] test 6 (384 bit key, 64 byte blocks): 1572391 operations in 1 seconds (100633024 bytes)
[  296.754760] test 7 (384 bit key, 256 byte blocks): 527241 operations in 1 seconds (134973696 bytes)
[  297.757259] test 8 (384 bit key, 1024 byte blocks): 150210 operations in 1 seconds (153815040 bytes)
[  298.763871] test 9 (384 bit key, 8192 byte blocks): 19504 operations in 1 seconds (159776768 bytes)
[  299.770425] test 10 (512 bit key, 16 byte blocks): 3157185 operations in 1 seconds (50514960 bytes)
[  300.777072] test 11 (512 bit key, 64 byte blocks): 1579551 operations in 1 seconds (101091264 bytes)
[  301.783745] test 12 (512 bit key, 256 byte blocks): 526692 operations in 1 seconds (134833152 bytes)
[  302.790244] test 13 (512 bit key, 1024 byte blocks): 150220 operations in 1 seconds (153825280 bytes)
[  303.796840] test 14 (512 bit key, 8192 byte blocks): 19498 operations in 1 seconds (159727616 bytes)

-- 
Regards/Gruss,
Boris.
